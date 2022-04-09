//
//  Timer.swift
//  Timer
//
//  Created by WONJI HA on 2021/12/08.
//

//https://unclean.tistory.com/27 타이머3

import Foundation
import UIKit
import AVFoundation //햅틱
import GoogleMobileAds


class MainTimer: UIViewController {
  
    var timer = Timer()
    var timerstatus : Bool = false
    var count : Double = 0
    


    var startTime = Date()
    var timeInterval : Double = 500
    
    var hour = 0 // 분을 12로 나누어 시를 구한다
    var minute = 0 // 초를 60으로 나누어 분을 구한다
    var second = 0 // 초를 구한다
    var milliSecond = 0
    
    
       
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
        
        //Background
//        let notificationCenter = NotificationCenter.default
//        notificationCenter.addObserver(self, selector: #selector(BackgroundTime), name: UIApplication.willResignActiveNotification, object: nil)
//        notificationCenter.addObserver(self, selector: #selector(ForegroundTime), name: UIApplication.willEnterForegroundNotification, object: nil)
         /* Admob */
      //  bannerView.adUnitID = "ca-app-pub-7875242624363574/7192134359"
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716" //테스트 광고
        bannerView.rootViewController = self
        bannerView.load(GADRequest())

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    enum WatchStatus {
        case start
        case stop
    }
    
    var watchStatus: WatchStatus = .start
    
    @IBAction func Start_StopButton(_ sender: Any)
    {
        switch self.watchStatus {
        case .start:
            self.watchStatus = .stop
            self.timer = Timer.scheduledTimer(timeInterval: 0.001,target: self,selector: #selector(timerCounter),userInfo: nil,repeats: true)
            self.startTime = Date()
            
            case .stop: // 기록 기능
            self.watchStatus = .start
    }

    }
        
      
    
    
    func Reset() /* 초기화 함수 선언 */
    {
        //timercount = false
        timerstatus = true
        self.timer.invalidate()
        //self.StartStopButton.setTitle("Start", for: .normal)
        self.count = 0
        self.timeInterval = 0
        
        self.HourLabel.text = "00"
        self.MinLabel.text = "00"
        self.SecLabel.text = "00"
        self.MillisecLabel.text = "00"

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
    
    func timeLabel()
    {
//        let time = secondsToHoursMinutesSeconds(seconds: count)
//        let timeText = makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
//        TimerLabel.text = timeText

        let time = CalTime(ms: Int(count))
        let timeText = TimeString(hours: time.0, minutes: time.1, seconds: time.2, milliseconds: time.3)
        //TimeLabel.text = timeText

    }
    

    
    @objc func timerCounter()
    {
//        if(timeInterval > -0.99){
//            timer.invalidate()
//            Reset()
//        }
        let timeInterval = Date().timeIntervalSince(startTime)
           // timeInterval += 10
            //count = timeInterval
           
            hour = (Int)(fmod((timeInterval/60/60), 12)) // 분을 12로 나누어 시를 구한다
            minute = (Int)(fmod((timeInterval/60), 60)) // 초를 60으로 나누어 분을 구한다
            second = (Int)(fmod(timeInterval, 60)) // 초를 구한다
            milliSecond = (Int)((timeInterval - floor(timeInterval))*1000)
            
        self.HourLabel.text = String(format: "%02d", hour)
        self.MinLabel.text = String(format: "%02d", minute)
        self.SecLabel.text = String(format: "%02d", second)
        self.MillisecLabel.text = String(format: "%03d", milliSecond)
        
        print("time:",timeInterval)
//        print("hour:", HourLabel.text)
//        print("min:", MinLabel.text)
//        print("sec:", SecLabel.text)
        print("millisec:", MillisecLabel)
        //print("count:", count)
       // print("startTime:", startTime)
        //print("밀리초:",milliSecond)
            
        
         
        
                                    
    }
    
    func CalTime(ms: Int) -> (Int, Int, Int, Int)
    {
        return ((ms / 3600000), ((ms % 3600000) / 60000), ((ms % 60000) / 1000), (ms % 3600000) % 1000) //1시간을 1밀리초로 환산하여 계산함. ex)3600000밀리초는 1시간
    }
    
    func TimeString(hours: Int, minutes: Int, seconds : Int, milliseconds : Int) -> String  //시간을 스트리밍값으로 변환
    {
        var timeString = ""
        timeString += String(format: "%02d", hours)
        timeString += ":"
        timeString += String(format: "%02d", minutes)
        timeString += ":"
        timeString += String(format: "%02d", seconds)
        timeString += "."
        timeString += String(format: "%03d", milliseconds)
        return timeString
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
    
//    func secondsToHoursMinutesSeconds(seconds: Int) -> (Int, Int, Int)
//    {
//        return ((seconds / 3600), ((seconds % 3600) / 60),((seconds % 3600) % 60))
//    }
//
//    func makeTimeString(hours: Int, minutes: Int, seconds : Int) -> String
//    {
//        var timeString = ""
//        timeString += String(format: "%02d", hours)
//        timeString += ":"
//        timeString += String(format: "%02d", minutes)
//        timeString += ":"
//        timeString += String(format: "%02d", seconds)
//        return timeString
//    }
    
    func UpAlertError()
    {
        let alert = UIAlertController(title: "알림", message: "타이머는 23시까지만 설정가능합니다.", preferredStyle: .alert)
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
        if(count < 82800000)
        {
            count += 0.001
            Effect()
            //MillisecLabel.text = "\(count)"
            MillisecLabel.text = "\((count - floor(count))*1000)"

            //MillisecLabel.text = String(format: "%03d", count)
         
            print(timeInterval,"m시간을 증가 하였습니다")
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
            count -= 1
            Effect()
            print(count,"m시간을 감소 하였습니다")
            //MillisecLabel()
        }
        else
        {
            DownAlertError()
        }
    }
    
    @IBAction func secUp(_ sender:Any)
    {
        if(count < 82800000)
        {
            count += 1
            Effect()
            print(count,"s시간을 증가 하였습니다")
            SecLabel.text = "\(floor(count))"
        }
        else
        {
            UpAlertError()
        }

    }
    
    @IBAction func secDown( _ sender : Any)
    {
        if(count > 999)
        {
            if(count > 0)
            {
                count -= 1000
                Effect()
                print(count, "s시간을 감소 하였습니다")
                timeLabel()
            }
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
        if(count < 82800000)
        {
            count += 60000
            Effect()
            print(count, "분시간이 증가 하였습니다")
            timeLabel()
        }

        else
        {
            UpAlertError()
        }
    }
    
    @IBAction func minDown(_ sender : Any)
    {
        if(count > 59999)
        {
            if(count > 0)
            {
              count -= 60000
                Effect()
                print(count, "분시간이 감소 하였습니다")
                    timeLabel()
            }
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
        if(count < 82800000)
        {
            count += 3600000
            Effect()
            print(count, "h시간이 증가 하였습니다")
            timeLabel()
        }
        else
        {
            UpAlertError()
        }
    }
    
    @IBAction func hourDown(_ sender : Any)
    {
        if(count > 3599999)
        {
            if(count > 0)
            {
                count -= 3600000
                Effect()
                print(count, "h시간이 감소 하였습니다")
                timeLabel()
            }
        }
        else
        {   DownAlertError()
            print("h 시간이 충분히 남아 있지 않아 시간을 감소할 수 없습니다.")
            print(count, "시간이 저장되어있다.")
        }
       
    }
    
}
