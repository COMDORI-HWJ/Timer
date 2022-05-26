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
 https://80000coding.oopy.io/0bd77cd3-7dc7-4cf4-93ee-8ca4fbca898e 가드문 사용법 (if문보다 빠르게 끝낸다)
 https://jesterz91.github.io/ios/2021/04/07/ios-notification/ UserNotification 프레임워크를 이용한 알림구현
 https://twih1203.medium.com/swift-usernotification%EC%9C%BC%EB%A1%9C-%EC%9D%B4%EB%AF%B8%EC%A7%80%EA%B0%80-%ED%8F%AC%ED%95%A8%EB%90%9C-%EB%A1%9C%EC%BB%AC-%EC%95%8C%EB%A6%BC-%EB%B3%B4%EB%82%B4%EA%B8%B0-5a7ef07fa2ec UserNotification으로 이미지가 포함된 로컬 알림 보내기
 https://gonslab.tistory.com/27 푸시 알림 권한
 
 */

import Foundation
import UIKit
import AVFoundation //햅틱
import GoogleMobileAds
import UserNotifications
import SystemConfiguration

class MainTimer: UIViewController {
    
    let storyboardId = "MTimer"
    let appName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as! String
    //let appName = infoDictionary["CFBundleDisplayName"] as! String
    

  
    var timer = Timer()
    var TimerStatus : Bool = false // 타이머 상태
    var count : Double = 0
    var remainTime : Double = 0
    var elapsed : Double = 0 // 경과시간
    
    let Noti = UNMutableNotificationContent()
    let notiCenter = UNUserNotificationCenter.current()
    var DisplayName = "MTimer"

    var hour = 0
    var minute = 0
    var second = 0
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
        
        requestNotiAuthorization()
        requestNotificationPermission()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//    deinit
//    {
//        Reset() //인스턴스 메모리 해제가 필요할 때 자동으로 호출하는 "소멸자" 함수 https://woozzang.tistory.com/116 //단 백그라운드 작업 안됨.
//    }
    
    //var timerStatus: TimerStatus = .start
    
    func requestNotificationPermission(){  //푸시 알림 권한 메소드
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge,.criticalAlert], completionHandler: {didAllow,Error in
               if didAllow {
                   print("Push: 권한 허용")
               } else {
                   print("Push: 권한 거부")
               }
           })
       }
    
    @IBAction func TimerStartStop(_ sender: Any)
    {
        let startTime = Date()

        if TimerStatus
        {
            TimerStatus = false
            count = count - elapsed //일시정지 동안 카운트된 시간을 빼서 카운트를 줄인다(일시정지후 초기화 안됨)
            timer.invalidate()
            StartStopButton.setTitle("Start", for: .normal)

        }
        else if (count > 0)
        {
            TimerStatus = true
            StartStopButton.setTitle("Pause", for: .normal)
            DispatchQueue.main.async {
                // Timer카운터 쓰레드 적용
                self.timer = Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true, block: { [weak self] timer in
                    let timeInterval = Date().timeIntervalSince(startTime)
                    self!.remainTime = self!.count - timeInterval // 남은시간 계산
                    self!.elapsed = self!.count - self!.remainTime
                    
                /** ceil(값) = 소수점 올림  floor(값) = 소수점 내림  trunc(값) = 소수점 버림  round(값) = 소수점 반올림     */
                    
                    guard self!.remainTime >= trunc(0) else
                    {
                        if(SettingTableCell.soundCheck == true)
                        {
                            self?.sendNotification()  // Local Notification 발생
                            print("Sound: ",SettingTableCell.soundCheck)
                            AudioServicesPlaySystemSound(1016) // "트윗" 소리발생
                            AudioServicesPlaySystemSound(4095) // 진동발생
                        }
                        else if(SettingTableCell.soundCheck == false)
                        {
                            print("Sound: ",SettingTableCell.soundCheck)
                        }
                        
                        self?.Reset()
                        print("0초")
                        return print("초기화 완료")

                    }
                    self!.Timecal()
                    
//                    if(self!.remainTime >= trunc(0))
//                    {
//                        self!.Timecal()
////                        if(self!.remainTime < 0)
////                        {
////                            self?.Reset()
////                            print("0초, 초기화")
////                        }
//
//                    }
            })
                //RunLoop.current.run() //메인쓰레드에서는 불안정하게 작동함.
                
                }
        }
        else
        {
            print("카운트를 시작하지 못하였습니다.")
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
    
    func sendNotification()
    {

        Noti.title = appName
        Noti.subtitle = "타이머 완료"
        Noti.body = "0초가 되었습니다. 타이머를 다시 작동하려면 알림을 터치!"
        Noti.badge = 1
        Noti.sound = UNNotificationSound.default
        
        //let notificationCenter = UNUserNotificationCenter.current()
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false) //알림 발생 시기
        let identifier = "TimerNoti" //알림 고유 이름
        let request = UNNotificationRequest(identifier: identifier, content: Noti, trigger: nil) //알림 등록 결과
        notiCenter.add(request) { (error) in
            if let err = error {
                print("노티피케이션 알림 오류: ", err.localizedDescription)
            }
            else{
                print("노티피케이션 푸쉬알림 성공")
            }
        }
    }
    
    @Published var notiTime: Date = Date() {
            didSet {
                removeAllNotifications()
            }
        }

        @Published var isAlertOccurred: Bool = false

        func removeAllNotifications() {
            notiCenter.removeAllDeliveredNotifications()
            notiCenter.removeAllPendingNotificationRequests()
        }
    
    func requestNotiAuthorization() //노티피케이션 설정 가져오기 개발중
    {
        notiCenter.getNotificationSettings { settings in

                   // 승인되어있지 않은 경우 request
                   if settings.authorizationStatus != .authorized {
                       self.notiCenter.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                           if let error = error {
                               print("Error : \(error)")
                           }
                   
                           // 노티피케이션 최초 승인
                          
                           }
                       
                   

                   // 거부되어있는 경우 alert
                   if settings.authorizationStatus == .denied {
                       // 알림 띄운 뒤 설정 창으로 이동
                       DispatchQueue.main.async {
                           self.isAlertOccurred = true
                       }
                   }
    }
        }
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
        if(count < 356400) //99시간으로 제한(3자리 시간적용시 레이아웃깨짐)
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

//extension Bundle
//{
//    class var appName : String {
//        if let value = Bundle.main.infoDictionary?["CFBundleDispalyName"] as? String {
//            return value
//        }
//        return ""
//    }
//}
