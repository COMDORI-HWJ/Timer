//
//  Stopwatch.swift
//  Timer
//
//  Created by Wonji Ha on 2022/06/16.
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
 https://inuplace.tistory.com/1163 로컬라이징
 https://fomaios.tistory.com/entry/Swift-Enum%EC%97%B4%EA%B1%B0%ED%98%95%EC%9D%84-%EC%8D%A8%EC%95%BC-%ED%95%98%EB%8A%94-%EC%9D%B4%EC%9C%A0 Enum 열거형 이란?
 */

import Foundation
import UIKit
import AVFoundation //햅틱
import GoogleMobileAds
import UserNotifications
import SystemConfiguration

class Stopwatch: UIViewController {
    
    let appName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as! String
    //let appName = infoDictionary["CFBundleDisplayName"] as! String
      
    var timer = Timer()
    var startTime = Date()
    var TimerStatus : Bool = false // 타이머 상태

    var remainTime : Double = 0
    var elapsed : Double = 0 // 경과시간
    var count : Double = 0
  
    var Firstcount: Double = 0 //처음 시작한 카운트 <추후 db연동후 사용자가 많이 사용하는 시간 빅데이터화...>
    
    let Noti = UNMutableNotificationContent()
    let notiCenter = UNUserNotificationCenter.current()

    var hour = 0
    var minute = 0
    var second = 0
    var milliSecond = 0

    var recordList: [String] = [] //스톱워치 시간 기록 배열

       
    @IBOutlet weak var TimeLabel: UILabel!
    
    @IBOutlet weak var HourLabel: UILabel!
    @IBOutlet weak var MinLabel: UILabel!
    @IBOutlet weak var SecLabel: UILabel!
    @IBOutlet weak var MillisecLabel: UILabel!
    
    @IBOutlet weak var StartStopButton: UIButton!
    @IBOutlet weak var RecordResetButton: UIButton!
    
    @IBOutlet weak var TimeTableView: UITableView!
    
    
    
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
    
    enum StopwatchStatus {
        case start, stop
    }
    //var stopwatchStatus: StopwatchStatus = .start
    
    @IBAction func StopwatchStartStop(_ sender: Any)
    {
        startTime = Date()
        if (TimerStatus)
        {
            TimerStatus = false
            count = elapsed - count //일시정지 동안 경과된 시간(흐르는 시간)을 저장된 시간에서 빼준다.
            timer.invalidate()
            StartStopButton.setTitle("Start", for: .normal)
            RecordResetButton.setTitle("초기화", for: .normal)
            
        }
        else
        {
          
            TimerStatus = true
            StartStopButton.setTitle("Pause", for: .normal)
            RecordResetButton.setTitle("기록", for: .normal)
            print("일시정지")
                    DispatchQueue.main.async {
                        // Timer카운터 쓰레드 적용
                        self.timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(self.timerCounter), userInfo: nil, repeats: true)
                    }
            
        }
    }
    
    
//    @IBAction func StopwatchStartStop1(_ sender: Any)
//    {
//         startTime = Date()
//        if TimerStatus
//        {
//            TimerStatus = false
//            count = elapsed - count //일시정지 동안 경과된 시간을 저장된 시간에서 빼준다.
//            timer.invalidate()
//            StartStopButton.setTitle("Start", for: .normal)
//
//        }
//        else
//        {
//            TimerStatus = true
//            StartStopButton.setTitle("Pause", for: .normal)
//            DispatchQueue.main.async {
//                // Timer카운터 쓰레드 적용
//                self.timer = Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true, block: { [weak self] timer in
//                    let timeInterval = Date().timeIntervalSince(self!.startTime)
//                    self!.remainTime = self!.count + timeInterval // 남은시간 계산
//                    self!.elapsed = self!.count + self!.remainTime
//
//                /** ceil(값) = 소수점 올림  floor(값) = 소수점 내림  trunc(값) = 소수점 버림  round(값) = 소수점 반올림     */
//
////                    guard self!.remainTime >= trunc(0) else
////                    {
////                        if(SettingTableCell.soundCheck == true)
////                        {
////                            self?.sendNotification()  // Local Notification 발생
////                            print("Sound: ",SettingTableCell.soundCheck)
////                            AudioServicesPlaySystemSound(1016) // "트윗" 소리발생
////                            AudioServicesPlaySystemSound(4095) // 진동발생
////                        }
////                        else if(SettingTableCell.soundCheck == false)
////                        {
////                            print("Sound: ",SettingTableCell.soundCheck)
////                        }
////
////                        self?.Reset()
////                        print("0초")
////                        return print("초기화 완료")
////
////                    }
//                    self!.Timecal()
//
//            })
//                //RunLoop.current.run() //메인쓰레드에서는 불안정하게 작동함.
//
//                }
//        }
//
//
//    }
    
    func Timecal()
    {
        hour = (Int)(fmod((remainTime/60/60), 100)) // 분을 12로 나누어 시를 구한다
        minute = (Int)(fmod((remainTime/60), 60)) // 초를 60으로 나누어 분을 구한다
        second = (Int)(fmod(remainTime, 60)) // 초를 구한다
        milliSecond = (Int)((remainTime - floor(remainTime))*1000)
        
        TimeLabel.text = String(format: "%02d:", hour)+String(format: "%02d:", minute)+String(format: "%02d.", second)+String(format: "%03d", milliSecond)
        
        print("hour time:", hour)
        print("min time:", minute)
        print("sec time:", second)
        print("millisec time:", milliSecond)
        print("remainTime:", remainTime)
        print("경과시간:", elapsed)
        print("남은 카운트:", count)
        //print("첫번째 카운트: \(Firstcount)")
       dump("첫번째 카운트: \(Firstcount)")
       
        //return ((ms / 3600000), ((ms % 3600000) / 60000), ((ms % 60000) / 1000), (ms % 3600000) % 1000) //1시간을 1밀리초로 환산하여 계산함. ex)3600000밀리초는 1시간
    }
    

    
    
//    @IBAction func StopwatchStartStop(_ sender: Any)
//    {
//        startTime = Date()
//        switch stopwatchStatus {
//        case .start:
//            stopwatchStatus = .start
//
//            StartStopButton.setTitle("Pause", for: .normal)
//            DispatchQueue.main.async {
//                // Timer카운터 쓰레드 적용
//                self.timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(self.timerCounter), userInfo: nil, repeats: true)
//
//        }
//            print("2")
//        case .stop:
//            stopwatchStatus = .stop
//            self.timer.invalidate()
//            StartStopButton.setTitle("Start", for: .normal)
//            print("1")
//        }
//    }
    
    @objc private func timerCounter() -> Void
    {

        let timeInterval = Date().timeIntervalSince(startTime)
        remainTime = count + timeInterval // 남은시간 계산
        elapsed = count + remainTime

        /** ceil(값) = 소수점 올림  floor(값) = 소수점 내림  trunc(값) = 소수점 버림  round(값) = 소수점 반올림     */

//            guard timeInterval <= trunc(356400) else
//            {
//                if(SettingTableCell.soundCheck == true)
//                {
//                    sendNotification()  // Local Notification 발생
//                    print("Sound: ",SettingTableCell.soundCheck)
//                    AudioServicesPlaySystemSound(1016) // "트윗" 소리발생
//                    AudioServicesPlaySystemSound(4095) // 진동발생
//                }
//                else if(SettingTableCell.soundCheck == false)
//                {
//                    print("Sound: ",SettingTableCell.soundCheck)
//                }
//
//                //Reset()
//                print("99시간 끝")
//                return print("초기화 완료")
//
//            }



        hour = (Int)(fmod((remainTime/60/60), 100)) // 분을 12로 나누어 시를 구한다
        minute = (Int)(fmod((remainTime/60), 60)) // 초를 60으로 나누어 분을 구한다
        second = (Int)(fmod(remainTime, 60)) // 초를 구한다
        milliSecond = (Int)((remainTime - floor(remainTime))*1000)

        TimeLabel.text = String(format: "%02d:", hour)+String(format: "%02d:", minute)+String(format: "%02d.", second)+String(format: "%03d", milliSecond)
//        HourLabel.text = String(format: "%02d", hour)
//        MinLabel.text = String(format: "%02d", minute)
//        SecLabel.text = String(format: "%02d", second)
//        MillisecLabel.text = String(format: "%03d", milliSecond)

//        print("hour time:", hour)
//        print("min time:", minute)
//        print("sec time:", second)
//        print("millisec time:", milliSecond)
//
//        print("남은 카운트:", count)
        //print("첫번째 카운트: \(Firstcount)")
       //dump("첫번째 카운트: \(Firstcount)")

        //return ((ms / 3600000), ((ms % 3600000) / 60000), ((ms % 60000) / 1000), (ms % 3600000) % 1000) //1시간을 1밀리초로 환산하여 계산함. ex)3600000밀리초는 1시간
        

        
        
    }
   
    func Reset() /* 초기화 함수 선언 */
    {
        TimerStatus = false
        timer.invalidate()
        count = 0
        remainTime = 0
        elapsed = 0
        recordList.removeAll() // 스톱워치 기록 배열 초기화

        StartStopButton.setTitle("Start", for: .normal)
        RecordResetButton.setTitle("초기화", for: .normal)

        Firstcount = 0
        TimeLabel.text = "00:00:00.000"
//        HourLabel.text = "00"
//        MinLabel.text = "00"
//        SecLabel.text = "00"
//        MillisecLabel.text = "000"
        print("초기화 남은 카운트:", count)
        

        
    }
    
    @IBAction func RecordResetButton(_ sender: Any)
    {
        if (TimerStatus == true) {
            let record = "\(hour):\(minute):\(second):\(milliSecond)" //스톱워치 시간을 기록
            recordList.append(record)
            print(recordList)

        }
        else {
            Reset() //초기화 함수 호출
            print("초기화 되었습니다.")
        }

        
    }
    
//    func CountLabel()
//    {
//        /*        3600==1시간        60==1분        1==1초        0.001==1밀리초        */
//        HourLabel.text = String(format: "%02d", (Int)(fmod((count/60/60), 100)))
//        MinLabel.text = String(format: "%02d", (Int)(fmod((count/60), 60)))
//        SecLabel.text = String(format: "%02d", (Int)(fmod(count, 60)))
//        MillisecLabel.text = String(format: "%03d", (Int)((count - floor(count))*1000))
//        print("계산된 카운트:", count)
//        //            MillisecLabel.text = "\((count - floor(count))*1000)"
//
//    }
    
  
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
        Noti.subtitle = String(format: NSLocalizedString("Timer done", comment: ""))
        Noti.body = "0초가 되었습니다. 타이머를 다시 작동하려면 알림을 터치하세요!"
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
                print("노티피케이션 푸시알림 성공")
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
        let alert = UIAlertController(title: String(format: NSLocalizedString("Warning", comment: "")), message: String(format: NSLocalizedString("It can be set up to 99 o'clock.", comment: "")), preferredStyle: .alert)
//        let alert = UIAlertController(title: "알림", message: "타이머는 99시까지만 설정가능합니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
    }
    
    func DownAlertError ()
    {
        let alert = UIAlertController(title: String(format: NSLocalizedString("Error", comment: "")), message: String(format: NSLocalizedString("Time is no", comment: "시간없음")), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: String(format: NSLocalizedString("OK", comment: "")), style: .default))
        present(alert, animated: true, completion: nil)
    }
    
}
