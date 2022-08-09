//  Timer
//  MainTimer.swift(3600(1시간)밀리초에서 빼는 방식의 타이머)
//  Created by WONJI HA on 2021/12/08.
//

/* Reference
 https://noahlogs.tistory.com/9 [기초]변수와 상수
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
 https://velog.io/@brillantescene/%EC%8A%A4%EC%9C%84%ED%94%84%ED%8A%B8-%ED%8C%8C%EC%9D%BC-%EC%A0%95%EB%A6%AC 프로젝트 구조 정리1
 https://mini-min-dev.tistory.com/15 프로젝트 구조 정리2(프로젝트 폴더링)
 https://boidevelop.tistory.com/62?category=839928 텍스트 필드 개념
 https://scshim.tistory.com/220 UIAlert 알림창 구현
 https://boidevelop.tistory.com/57 알림창 텍스트필드 추가
 https://stackoverflow.com/questions/33658521/how-to-make-a-uilabel-clickable UILable 터치이벤트
 */

import Foundation
import UIKit
import AVFoundation //햅틱
import GoogleMobileAds
import UserNotifications
import SystemConfiguration

class MainTimer: UIViewController {
    
    let appName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as! String
    //let appName = infoDictionary["CFBundleDisplayName"] as! String
      
    var hour = 0, minute = 0, second = 0, milliSecond = 0

    var timer = Timer()
    var TimerStatus : Bool = false // 타이머 상태
    var count : Double = 0, remainTime : Double = 0
    var elapsed : Double = 0 // 경과시간
    var Firstcount: Double = 0 //처음 시작한 카운트 <추후 db연동후 사용자가 많이 사용하는 시간 빅데이터화...>
    
    let Noti = UNMutableNotificationContent()
    let notiCenter = UNUserNotificationCenter.current()
   
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
    
    @IBOutlet weak var TipLabel: UILabel!
    
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

        Enable()
        tipLabel()
        
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
            StartStopButton.setTitle(String(format: NSLocalizedString("시작", comment: "Start")), for: .normal)
            
            Enable()

        }
        else if (count > 0)
        {
            TimerStatus = true
            StartStopButton.setTitle(String(format: NSLocalizedString("일시중지", comment: "Pause")), for: .normal)
            DispatchQueue.main.async {
                // Timer카운터 쓰레드 적용
                self.timer = Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true, block: { [weak self] timer in
                    let timeInterval = Date().timeIntervalSince(startTime)
                    self!.remainTime = self!.count - timeInterval // 남은시간 계산
                    self!.elapsed = self!.count - self!.remainTime
                    
                /** ceil(값) = 소수점 올림  floor(값) = 소수점 내림  trunc(값) = 소수점 버림  round(값) = 소수점 반올림 **/
                    
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
        hour = (Int)(fmod((remainTime/60/60), 100)) // 분을 12로 나누어 시를 구한다 * 100으로 설정해야 99시를 넘기지 않음.
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
        //print("첫번째 카운트: \(Firstcount)")
       dump("첫번째 카운트: \(Firstcount)")
       
        //return ((ms / 3600000), ((ms % 3600000) / 60000), ((ms % 60000) / 1000), (ms % 3600000) % 1000) //1시간을 1밀리초로 환산하여 계산함. ex)3600000밀리초는 1시간
        
        /* 타이머 작동중 버튼 비활성화 */
        Disable()

    }
   
    func Reset() /* 초기화 함수 선언 */
    {
        TimerStatus = false
        timer.invalidate()
        count = 0
        remainTime = 0
        elapsed = 0
        self.StartStopButton.setTitle(String(format: NSLocalizedString("시작", comment: "Start")), for: .normal)
       
        hour = 0
        minute = 0
        second = 0
        milliSecond = 0
   
        HourLabel.text = "00"
        MinLabel.text = "00"
        SecLabel.text = "00"
        MillisecLabel.text = "000"
        print("초기화 남은 카운트:", count)

        Enable()

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
        MillisecLabel.text = String(format: "%03d", (Int)((count - floor(count))*1001)) //1001을 곱해줘야 밀리초가 정상표시됨.
        
//            hour = (Int)(fmod((count/3600), 100)) // 분을 12로 나누어 시를 구한다
//            minute = (Int)(fmod((count/60), 60)) // 초를 60으로 나누어 분을 구한다
//            second = (Int)(fmod(count/1, 60)) // 초를 구한다
//            milliSecond = (Int)((count - floor(count))*1000)
//
//            HourLabel.text = String(format: "%02d", hour)
//            MinLabel.text = String(format: "%02d", minute)
//            SecLabel.text = String(format: "%02d", second)
//            MillisecLabel.text = String(format: "%03d", milliSecond)

            print("계산된 카운트:", count)
            print("밀리초: ", milliSecond)
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
        Noti.subtitle = String(format: NSLocalizedString("타이머 완료", comment: "Timer done"))
        Noti.body = String(format: NSLocalizedString("0초가 되었습니다. 타이머를 다시 작동하려면 알림을 탭하세요!", comment: ""))
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
        let alert = UIAlertController(title: String(format: NSLocalizedString("경고", comment: "Warning")), message: String(format: NSLocalizedString("타이머는 99시까지만 설정가능합니다.(설정할 수 있는 최대 시간값을 넘겼습니다)", comment: "")), preferredStyle: .alert)
//        let alert = UIAlertController(title: "알림", message: "타이머는 99시까지만 설정가능합니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
    }
    
    func DownAlertError ()
    {
        let alert = UIAlertController(title: String(format: NSLocalizedString("오류!", comment: "Error")), message: String(format: NSLocalizedString("시간이 충분히 남아 있지 않아 시간을 감소할 수 없습니다.", comment: "Time is no")), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: String(format: NSLocalizedString("확인", comment: "OK")), style: .destructive))
        present(alert, animated: true, completion: nil)
    }
    
    
    func Enable() //증감 버튼 및 시간레이블 활성화 메소드
    {
        hourUpButton.isEnabled = true
        hourDownButton.isEnabled = true
        minUpButton.isEnabled = true
        minDownButton.isEnabled = true
        secUpButton.isEnabled = true
        secDownButton.isEnabled = true
        millisecUpButton.isEnabled = true
        millisecDownButton.isEnabled = true
        
        let Hourtap = UITapGestureRecognizer(target: self, action: #selector(MainTimer.HourLabeltap))
        HourLabel.addGestureRecognizer(Hourtap)
        HourLabel.isUserInteractionEnabled = true
        let Mintap = UITapGestureRecognizer(target: self, action: #selector(MainTimer.MinLabeltap))
        MinLabel.addGestureRecognizer(Mintap)
        MinLabel.isUserInteractionEnabled = true
        let Sectap = UITapGestureRecognizer(target: self, action: #selector(MainTimer.SecLabeltap))
        SecLabel.addGestureRecognizer(Sectap)
        SecLabel.isUserInteractionEnabled = true
        let Millisectap = UITapGestureRecognizer(target: self, action: #selector(MainTimer.MillisecLabeltap))
        MillisecLabel.addGestureRecognizer(Millisectap)
        MillisecLabel.isUserInteractionEnabled = true

    }
    
    func Disable() //증감 버튼 및 시간레이블 비활성화 메소드
    {
        hourUpButton.isEnabled = false
        hourDownButton.isEnabled = false
        minUpButton.isEnabled = false
        minDownButton.isEnabled = false
        secUpButton.isEnabled = false
        secDownButton.isEnabled = false
        millisecUpButton.isEnabled = false
        millisecDownButton.isEnabled = false
        
        HourLabel.isUserInteractionEnabled = false
        MinLabel.isUserInteractionEnabled = false
        SecLabel.isUserInteractionEnabled = false
        MillisecLabel.isUserInteractionEnabled = false

    }
    
    @IBAction func millisecUp(_ sender : Any)
    {
        if(count < 356400)
        {
            count += 0.001
            Firstcount += 0.001
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
            Firstcount -= 0.001
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
            Firstcount += 1
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
            Firstcount -= 1
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
            Firstcount += 60
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
            Firstcount -= 60
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
            Firstcount += 3600
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
           Firstcount -= 3600
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
    
    @objc func HourLabeltap(sender:UITapGestureRecognizer) {

        print("HourLabel tap working")
        Hourinput()
    }
    
    @objc func MinLabeltap(sender:UITapGestureRecognizer) {

        print("MinLabel tap working")
        Mininput()
    }
    
    @objc func SecLabeltap(sender:UITapGestureRecognizer) {

        print("SecLabel tap working")
        Secinput()
    }
    
    @objc func MillisecLabeltap(sender:UITapGestureRecognizer) {

        print("MillisecLabel tap working")
        Millisecinput()
    }
    
    //    @IBAction func Timeinput(_ sender: Any)
        func Hourinput()
        {
            let alert = UIAlertController(title: String(format: NSLocalizedString("타이머 시간을 입력하세요", comment: "Enter the timer hours")), message: String(format: NSLocalizedString("1시간은 1을 입력하면됩니다. 예) 99입력→99시간", comment: "")), preferredStyle: .alert)
            let ok = UIAlertAction(title: String(format: NSLocalizedString("확인", comment: "OK")), style: .default) { (_) in
                print("알림창에서 확인을 눌렀습니다.")
                if let txt = alert.textFields?.first {
                        if txt.text?.isEmpty != true { //https://jeonyeohun.tistory.com/87 타입추론 형 변환
                            print("입력값: ", txt.text!)
                            if let inputcount = Int(txt.text!){ // https://developer.apple.com/forums/thread/100634 숫자 판별
                                if inputcount < 356400 && txt.text!.count < 3 {
                                    self.count = Double(inputcount * 3600) + self.count
                                    self.CountLabel()
                                    print("입력한숫자값:", inputcount)
                                    print(type(of: inputcount))
                                } else {
                                    self.UpAlertError()
                                    print("99시간이 넘어간다.")
                                }
                            } else {
                                let alert = UIAlertController(title: String(format: NSLocalizedString("오류!", comment: "")), message: String(format: NSLocalizedString("시간은 숫자만 입력가능합니다.", comment: "")), preferredStyle: UIAlertController.Style.alert)
                                let ok = UIAlertAction(title: String(format: NSLocalizedString("확인", comment: "OK")), style: .destructive, handler: nil)
                                alert.addAction(ok)
                                self.present(alert, animated: false, completion: nil)
                                print("숫자가 아님.")
                            }
                    }
                    else {
                        print("입력값이 없습니다.")
                    }
                }
            }
            
            let cancel = UIAlertAction(title: String(format: NSLocalizedString("취소", comment: "Cancel")), style: .cancel)
            alert.addTextField() { (textField) in
                textField.placeholder = String(format: NSLocalizedString("이곳에 시간을 입력하세요.", comment: ""))
                textField.textContentType = .creditCardNumber //숫자 키패드
                textField.keyboardType = .numberPad
            }
            alert.addAction(ok)
            alert.addAction(cancel)
            present(alert, animated: true)
        }
    
    func Mininput()
    {
        let alert = UIAlertController(title: String(format: NSLocalizedString("타이머 분을 입력하세요", comment: "Enter the timer minutes")), message: String(format: NSLocalizedString("1분은 1을 입력하세요. 예) 33입력→33분", comment: "1 minutes = Enter 1 Ex) 33input → 33minutes")), preferredStyle: .alert)
        let ok = UIAlertAction(title: String(format: NSLocalizedString("확인", comment: "")), style: .default) { (_) in
            print("알림창에서 확인을 눌렀습니다.")
            if let txt = alert.textFields?.first {
                    if txt.text?.isEmpty != true {
                        print("입력값: ", txt.text!)
                        if let inputcount = Int(txt.text!){
                            if inputcount < 356400 && txt.text!.count < 3 {
                                self.count = Double(inputcount * 60) + self.count
                                self.CountLabel()
                                print("입력한숫자값:", inputcount)
                                print(type(of: inputcount))
                            } else {
                                self.UpAlertError()
                                print("99시간이 넘어간다.")
                            }
                        } else {
                            let alert = UIAlertController(title: String(format: NSLocalizedString("오류!", comment: "")), message: String(format: NSLocalizedString("시간은 숫자만 입력가능합니다.", comment: "")), preferredStyle: UIAlertController.Style.alert)
                            let ok = UIAlertAction(title: String(format: NSLocalizedString("확인", comment: "OK")), style: .destructive, handler: nil)
                            alert.addAction(ok)
                            self.present(alert, animated: false, completion: nil)
                            print("숫자가 아님.")
                        }
              
                }
                else {
                    print("입력값이 없습니다.")
                }
            }
        }
        
        let cancel = UIAlertAction(title: String(format: NSLocalizedString("취소", comment: "Cancel")), style: .cancel)
        
        alert.addTextField() { (textField) in
            textField.placeholder = String(format: NSLocalizedString("이곳에 분을 입력하세요.", comment: ""))
            textField.textContentType = .creditCardNumber //숫자 키패드
            textField.keyboardType = .numberPad
            
        }
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    func Secinput()
    {
        let alert = UIAlertController(title: String(format: NSLocalizedString("타이머 초를 입력하세요", comment: "")), message: String(format: NSLocalizedString("1초는 1을 입력하세요. 예) 55입력→55초", comment: "")), preferredStyle: .alert)
        let ok = UIAlertAction(title: String(format: NSLocalizedString("확인", comment: "")), style: .default) { (_) in
            print("알림창에서 확인을 눌렀습니다.")
            if let txt = alert.textFields?.first {
                    if txt.text?.isEmpty != true {
                        print("입력값: ", txt.text!)
                        if let inputcount = Double(txt.text!){
                            if inputcount < 356400 {
                                self.count = Double(inputcount) + self.count
                                self.CountLabel()
                                print("입력한숫자값:", inputcount)
                                print(type(of: inputcount))
                            } else {
                                self.UpAlertError()
                                print("99시간이 넘어간다.")
                            }
                        } else {
                            let alert = UIAlertController(title: String(format: NSLocalizedString("오류!", comment: "")), message: String(format: NSLocalizedString("시간은 숫자만 입력가능합니다.", comment: "")), preferredStyle: UIAlertController.Style.alert)
                            let ok = UIAlertAction(title: String(format: NSLocalizedString("확인", comment: "OK")), style: .destructive, handler: nil)
                            alert.addAction(ok)
                            self.present(alert, animated: false, completion: nil)
                            print("숫자가 아님.")
                        }
              
                }
                else {
                    print("입력값이 없습니다.")
                }
            }
        }
        
        let cancel = UIAlertAction(title: String(format: NSLocalizedString("취소", comment: "Cancel")), style: .cancel)
        
        alert.addTextField() { (textField) in
            textField.placeholder = String(format: NSLocalizedString("이곳에 초를 입력하세요.", comment: ""))
            textField.textContentType = .creditCardNumber //숫자 키패드
            textField.keyboardType = .numberPad
            
        }
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    func Millisecinput()
    {
        let alert = UIAlertController(title: String(format: NSLocalizedString("타이머 밀리초를 입력하세요", comment: "")), message: String(format: NSLocalizedString("0.001초는 1을 입력하면됩니다. 예) 777입력→0.777밀리초", comment: "")), preferredStyle: .alert)
        let ok = UIAlertAction(title: String(format: NSLocalizedString("확인", comment: "OK")), style: .default) { (_) in
            print("알림창에서 확인을 눌렀습니다.")
            if let txt = alert.textFields?.first {
                    if txt.text?.isEmpty != true {
                        print("입력값: ", txt.text!)
                        if let inputcount = Double(txt.text!){
                            if inputcount < 356400 {
                                self.count = (inputcount * 0.001) + self.count
                                self.CountLabel()
                                print("입력한숫자값:", inputcount)
                                print(type(of: inputcount))
                            } else {
                                self.UpAlertError()
                                print("99시간이 넘어간다.")
                            }
                        } else {
                            let alert = UIAlertController(title: String(format: NSLocalizedString("오류!", comment: "")), message: String(format: NSLocalizedString("시간은 숫자만 입력가능합니다.", comment: "")), preferredStyle: UIAlertController.Style.alert)
                            let ok = UIAlertAction(title: String(format: NSLocalizedString("확인", comment: "OK")), style: .destructive, handler: nil)
                            alert.addAction(ok)
                            self.present(alert, animated: false, completion: nil)
                            print("숫자가 아님.")
                        }
              
                }
                else {
                    print("입력값이 없습니다.")
                }
            }
        }
        
        let cancel = UIAlertAction(title: String(format: NSLocalizedString("취소", comment: "Cancel")), style: .cancel)
        
        alert.addTextField() { (textField) in
            textField.placeholder = String(format: NSLocalizedString("이곳에 밀리초를 입력하세요.", comment: ""))
            textField.textContentType = .creditCardNumber //숫자 키패드
            textField.keyboardType = .numberPad
            
        }
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    private func tipLabel()
    {
        TipLabel.text = String(format: NSLocalizedString("빠르게 시간을 변경하려면 타이머 숫자를 탭하세요.\n시:분:초:밀리초", comment: ""))
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
