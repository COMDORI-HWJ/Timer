//
//  ViewController.swift
//  Timer
//
//  Created by WONJI HA on 2021/07/06.

/*
 Reference
 https://youtu.be/3TbdoVhgQmE 유튜브 참고
 https://www.youtube.com/watch?v=GzwLobVuXXI 백그라운드 타이머
 https://kwangsics.tistory.com/entry/Swift-%ED%95%A8%EC%88%98-%EC%A0%95%EC%9D%98%EC%99%80-%ED%98%B8%EC%B6%9C?category=606525 함수 정의 및 호출
 https://bite-sized-learning.tistory.com/175 타이머1
 https://youtu.be/3TbdoVhgQmE 타이머2
 
 */

import UIKit
import AVFoundation //햅틱
import GoogleMobileAds


class ViewController: UIViewController {
  
    var timer = Timer()
    var timercount : Bool = false
    var count : Int = 0
    
    @IBOutlet weak var TimeLabel: UILabel!
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
        
    @IBAction func Start_StopButton(_ sender: Any)
    {
        if timercount
        {
            timercount = false
            timer.invalidate()
            StartStopButton.setTitle("Start", for: .normal)
            
        }
        else if(count > 0)
        {
                timercount = true
                StartStopButton.setTitle("Pause", for: .normal)
                print("일시정지")
                timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
            
                /* 카운트다운 동안 시간 버튼 비활성화 */
                hourUpButton.isEnabled = false
                hourDownButton.isEnabled = false
                minUpButton.isEnabled = false
                minDownButton.isEnabled = false
                secUpButton.isEnabled = false
                secDownButton.isEnabled = false
                millisecUpButton.isEnabled = false
                millisecDownButton.isEnabled = false
            
        }
        else
        {
            print(count,"초 미만, 카운트 다운 실패")
        }
        
    }
    
    func Reset() /* 초기화 함수 선언 */
    {
        timercount = false
        self.timer.invalidate()
        self.StartStopButton.setTitle("Start", for: .normal)
        self.count = 0
        self.TimeLabel.text = self.TimeString(hours: 0, minutes: 0, seconds: 0, milliseconds: 0)
        hourUpButton.isEnabled = true
        hourDownButton.isEnabled = true
        minUpButton.isEnabled = true
        minDownButton.isEnabled = true
        secUpButton.isEnabled = true
        secDownButton.isEnabled = true
        millisecUpButton.isEnabled = true
        millisecDownButton.isEnabled = true
        
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

        let time = CalTime(ms: count)
        let timeText = TimeString(hours: time.0, minutes: time.1, seconds: time.2, milliseconds: time.3)
        TimeLabel.text = timeText
        
    }
    
    @objc func timerCounter() -> Void
    {
       // saveTime = Int(Date().timeIntervalSince(saveTime))
        if(count > 0)
        {
            count = count-8 //해결필요  어느정도 맞춤.
            
            print(count , "시간입니다")
            timeLabel()
            if(count == 0 || count < 0)
            {
                if(SettingTableCell.soundCheck == true)
                {
                    print("Sound: ",SettingTableCell.soundCheck)
                    AudioServicesPlaySystemSound(1016) // "트윗" 소리발생
                    AudioServicesPlaySystemSound(4095) // 진동발생
                }
                
                else if(SettingTableCell.soundCheck == false)
                {
                    print("Sound: ",SettingTableCell.soundCheck)
                }
              
                //AudioServicesPlaySystemSound(4095) // 진동발생
                Reset()
                print("0초가 되었습니다 및 초기화")
            }
        }
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
        let alert = UIAlertController(title: "오류", message: "시간이 충분히 남아 있지 않아 시간을 감소할 수 없습니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func millisecUp(_ sender : Any)
    {
        if(count < 82800000)
        {
            count += 1
            Effect()
            print(count,"m시간을 증가 하였습니다")
            timeLabel()
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
            timeLabel()
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
            count += 1000
            Effect()
            print(count,"s시간을 증가 하였습니다")
            timeLabel()
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

