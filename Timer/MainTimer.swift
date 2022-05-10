//  Timer
//  MainTimer.swift(3600(1시간)밀리초에서 빼는 방식의 타이머)
//  Created by WONJI HA on 2021/12/08.
//

/* Reference
 
https://unclean.tistory.com/27 타이머3 시작시간 카운트
https://ios-development.tistory.com/773 타이머4
https://ios-development.tistory.com/775 DispatchSourceTimer를 이용한 Timer 모듈 구현
https://www.clien.net/service/board/cm_app/17167370 클리앙 개발 문의
옵셔널 체이닝: 변수나 상수 뒤에 ? 또는 !느낌표를 사용하여 옵셔널에서 값을 강제 추출하는 효과가 있다. 사용을 지양하는 편이 좋다고 한다.
 
 */

import Foundation
import UIKit
import AVFoundation //햅틱
import GoogleMobileAds

class MainTimer: UIViewController {
  
    var timer = Timer()
    var TimerStatus : Bool = false // 타이머 상태
    var count : Double = 0
    var remainTime : Double = 0
    var elapsed : Double = 0 // 경과시간


    
    var hour = 0 // 분을 12로 나누어 시를 구한다
    var minute = 0 // 초를 60으로 나누어 분을 구한다
    var second = 0 // 초를 구한다
    var milliSecond = 0

//    enum timerStatus {
//        case start
//        case stop
//    }
//    var timerStatus: timerStatus = .start
       
    @IBOutlet weak var HourLabel: UILabel!
    @IBOutlet weak var MinLabel: UILabel!
    @IBOutlet weak var SecLabel: UILabel!
    @IBOutlet weak var MillisecLabel: UILabel!
    
    @IBOutlet weak var StartStopButton: UIButton!
    @IBOutlet weak var ResetButton: UIButton!
    
    @IBOutlet weak var hourUpButton: UIButton!
    @IBOutlet weak var hourDownButton: UIButton!
        
    @IBOutlet weak var minUpButton: UIButton!
    @IBOutlet weak var minDownButton: UIButton!
    
    @IBOutlet weak var secUpButton: UIButton!
    @IBOutlet weak var secDownButton: UIButton!
    
    @IBOutlet weak var millisecUpButton: UIButton!
    @IBOutlet weak var millisecDownButton: UIButton!
    
    @IBOutlet weak var bannerView: GADBannerView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.topItem?.title="AD" //뷰 제목
  
         /* Admob */
      //  bannerView.adUnitID = "ca-app-pub-7875242624363574/7192134359"
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716" //테스트 광고
        bannerView.rootViewController = self
        bannerView.load(GADRequest())

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//    deinit
//    {
//        Reset() //인스턴스 메모리 해제가 필요할 때 자동으로 호출하는 "소멸자" 함수 https://woozzang.tistory.com/116 //단 백그라운드 작업 안됨.
//    }
    
    //var timerStatus: TimerStatus = .start
    
    @IBAction func TimerStartStop(_ sender: Any)
    {
        let startTime = Date()

        if TimerStatus
        {
            TimerStatus = false
            count = count - elapsed
            timer.invalidate()

            StartStopButton.setTitle("Start", for: .normal)

        }
        else
        {
            TimerStatus = true
            StartStopButton.setTitle("Pause", for: .normal)
            DispatchQueue.main.async {
                // Timer카운터 쓰레드 적용
                self.timer = Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true, block: { [weak self] timer in
                    let timeInterval = Date().timeIntervalSince(startTime)
                    self!.remainTime = self!.count - timeInterval // 남은시간 계산
                    self!.elapsed = self!.count - self!.remainTime
                    if(self!.remainTime > trunc(-1)) /** ceil(값) = 소수점 올림  floor(값) = 소수점 내림  trunc(값) = 소수점 버림  round(값) = 소수점 반올림     */
                    {
                        self!.Timecal()
                        if(self!.remainTime < trunc(0))
                        {
                            self?.Reset()
                            print("0초, 초기화")
                        }

                    }
            })
                //RunLoop.current.run() //메인쓰레드에서는 불안정하게 작동함.
                
                }
        }


    }
    
    func Timecal()
    {
        hour = (Int)(fmod((remainTime/60/60), 100)) // 분을 12로 나누어 시를 구한다
        minute = (Int)(fmod((remainTime/60), 60)) // 초를 60으로 나누어 분을 구한다
        second = (Int)(fmod(remainTime, 60)) // 초를 구한다
        milliSecond = (Int)((remainTime - floor(remainTime))*1000)
        
        HourLabel.text = String(format: "%02d", hour)
        MinLabel.text = String(format: "%02d", minute)
        SecLabel.text = String(format: "%02d", second)
        MillisecLabel.text = String(format: "%03d", milliSecond)
        
        print("hour time:", hour)
        print("min time:", minute)
        print("sec time:", second)
        print("millisec time:", milliSecond)
        print("remainTime:", remainTime)
        print("경과시간:", elapsed)
        print("남은 카운트:", count)
        //return ((ms / 3600000), ((ms % 3600000) / 60000), ((ms % 60000) / 1000), (ms % 3600000) % 1000) //1시간을 1밀리초로 환산하여 계산함. ex)3600000밀리초는 1시간
    }
   
    func Reset() /* 초기화 함수 선언 */
    {
        TimerStatus = false
        timer.invalidate()
        count = 0
        remainTime = 0
        elapsed = 0
        self.StartStopButton.setTitle("Start", for: .normal)

        
        HourLabel.text = "00"
        MinLabel.text = "00"
        SecLabel.text = "00"
        MillisecLabel.text = "000"
        print("초기화 남은 카운트:", count)


//        hourUpButton.isEnabled = true
//        hourDownButton.isEnabled = true
//        minUpButton.isEnabled = true
//        minDownButton.isEnabled = true
//        secUpButton.isEnabled = true
//        secDownButton.isEnabled = true
//        millisecUpButton.isEnabled = true
//        millisecDownButton.isEnabled = true
        
    }
    
    @IBAction func ResetButton(_ sender: Any)
    {
        Reset() //초기화 함수 호출
        print("초기화 되었습니다.")
        
    }

    
    func CountLabel()
    {
        /*        3600==1시간        60==1분        1==1초        0.001==1밀리초        */
        HourLabel.text = String(format: "%02d", (Int)(fmod((count/60/60), 100)))
        MinLabel.text = String(format: "%02d", (Int)(fmod((count/60), 60)))
        SecLabel.text = String(format: "%02d", (Int)(fmod(count, 60)))
        MillisecLabel.text = String(format: "%03d", (Int)((count - floor(count))*1000))
        print("계산된 카운트:", count)
        //            MillisecLabel.text = "\((count - floor(count))*1000)"
        

    }
    
  
    func Effect() /*버튼을 누를때 발생하는 효과*/
    {
        if(SettingTableCell.vibrationCheck == true)
        {
            print("진동: ",SettingTableCell.vibrationCheck)
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred() // 탭틱 엔진이 있는 경우만 작동, 진동세기 강하게

        }else{
            print("진동: ",SettingTableCell.vibrationCheck)
        }
        //AudioServicesPlaySystemSound(1016) // 소리발생
    }
    
    
    func UpAlertError()
    {
        let alert = UIAlertController(title: "알림", message: "타이머는 99시까지만 설정가능합니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
    }
    
    func DownAlertError ()
    {
        let alert = UIAlertController(title: String(format: NSLocalizedString("Error", comment: "오류")), message: String(format: NSLocalizedString("Time is no", comment: "시간없음")), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func millisecUp(_ sender : Any)
    {
        if(count < 356400)
        {
            count += 0.001
            Effect()
            CountLabel()
        }

        else
        {
            UpAlertError()
        }
    }
    
    @IBAction func millisecDown(_ sender : Any)
    {
        if(count > 0)
        {
            count -= 0.001
            Effect()
            print(count,"m시간을 감소 하였습니다")
            CountLabel()
        }
        else
        {
            DownAlertError()
        }
    }
    
    @IBAction func secUp(_ sender:Any)
    {
        if(count < 356400)
        {
            count += 1
            CountLabel()
            Effect()
        }
        else
        {
            UpAlertError()
        }

    }
    
    @IBAction func secDown( _ sender : Any)
    {
        if(count > 0)
        {
            count -= 1
            Effect()
            print(count, "s시간을 감소 하였습니다")
            CountLabel()
        }
        else
        {
            DownAlertError()
            print("초가 충분히 남아 있지 않아 시간을 감소할 수 없습니다.")
            print(count, "시간이 저장되어있다.")
        }

       
    }
    
    @IBAction func minUp(_ sender : Any)
    {
        if(count < 356400)
        {
            count += 60
            Effect()
            CountLabel()
        }

        else
        {
            UpAlertError()
        }
    }
    
    @IBAction func minDown(_ sender : Any)
    {
        if(count > 0)
        {
            count -= 60
            Effect()
            print(count, "분시간이 감소 하였습니다")
            CountLabel()
        }
        else
        {
            DownAlertError()
            print("분 시간이 충분히 남아 있지 않아 시간을 감소할 수 없습니다.")
            print(count, "시간이 저장되어있다.")

        }
    }
    
    @IBAction func hourUp(_ sender : Any)
    {
        if(count < 356400)
        {
            count += 3600
            CountLabel()
            Effect()
        }
        else
        {
            UpAlertError()
        }
    }
    
    @IBAction func hourDown(_ sender : Any)
    {
       
       if(count > 0)
        {
           count -= 3600
           Effect()
           CountLabel()
       }
       else
       {
           DownAlertError()
           print("h 시간이 충분히 남아 있지 않아 시간을 감소할 수 없습니다.")
           print(count, "시간이 저장되어있다.")
       }
    }
}
