//  Timer
//  MainTimer.swift(3600(1시간)밀리초에서 빼는 방식의 타이머)
//  Created by WONJI HA on 2021/12/08.
//

/* Reference
 https://unclean.tistory.com/27 타이머3 시작시간 카운트
 https://ios-development.tistory.com/773 타이머4
 https://ios-development.tistory.com/775 DispatchSourceTimer를 이용한 Timer 모듈 구현
 https://80000coding.oopy.io/0bd77cd3-7dc7-4cf4-93ee-8ca4fbca898e 가드문 사용법 (if문보다 빠르게 끝낸다)
 https://jesterz91.github.io/ios/2021/04/07/ios-notification/ UserNotification 프레임워크를 이용한 알림구현
 https://twih1203.medium.com/swift-usernotification%EC%9C%BC%EB%A1%9C-%EC%9D%B4%EB%AF%B8%EC%A7%80%EA%B0%80-%ED%8F%AC%ED%95%A8%EB%90%9C-%EB%A1%9C%EC%BB%AC-%EC%95%8C%EB%A6%BC-%EB%B3%B4%EB%82%B4%EA%B8%B0-5a7ef07fa2ec UserNotification으로 이미지가 포함된 로컬 알림 보내기
 https://gonslab.tistory.com/27 푸시 알림 권한
 https://boidevelop.tistory.com/62?category=839928 텍스트 필드 개념
 https://scshim.tistory.com/220 UIAlert 알림창 구현
 https://boidevelop.tistory.com/57 알림창 텍스트필드 추가
 https://stackoverflow.com/questions/33658521/how-to-make-a-uilabel-clickable UILable 터치이벤트
 https://stackoverflow.com/questions/1080043/how-to-disable-multitouch 버튼 멀티터치 막기
 https://stackoverflow.com/questions/42319172/swift-3-how-to-make-timer-work-in-background 백그라운드 타이머 작동?
 https://paul-goden.tistory.com/11 타이머 백그라운드 참고
 https://eun-dev.tistory.com/24 노티 제거
 */

import Foundation
import UIKit
import AVFoundation // 햅틱
import UserNotifications
import SystemConfiguration
import GoogleMobileAds

class MainTimer: UIViewController {
    
    var hour = 0, minute = 0, second = 0, milliSecond = 0
    var timer = Timer()
    var timerStatus : Bool = false // 타이머 상태
    var count : Double = 0 // 타이머 시간
    var remainTime : Double = 0 // 남은 시간
    var elapsed : Double = 0 // 경과시간
    var backgroudTime : Date? // 백그라운드 경과시간
    
    let appName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as! String
    let notiContent = UNMutableNotificationContent()
    let notiCenter = UNUserNotificationCenter.current()
    
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var secLabel: UILabel!
    @IBOutlet weak var milliSecLabel: UILabel!
    
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    @IBOutlet weak var hourUpButton: UIButton!
    @IBOutlet weak var hourDownButton: UIButton!
    
    @IBOutlet weak var minUpButton: UIButton!
    @IBOutlet weak var minDownButton: UIButton!
    
    @IBOutlet weak var secUpButton: UIButton!
    @IBOutlet weak var secDownButton: UIButton!
    
    @IBOutlet weak var millisecUpButton: UIButton!
    @IBOutlet weak var millisecDownButton: UIButton!
    
    @IBOutlet weak var tipLabel: UILabel!
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIButton.appearance().isExclusiveTouch = true // 버튼 멀티터치 막기
        
        timerNoti() // 타이머 푸시 알림
        
        btnEnable()
        TipLabel()
        
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.topItem?.title="AD" //뷰 제목
        
        /* Admob */
        //        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716" // 테스트 광고
        bannerView.adUnitID = "ca-app-pub-7875242624363574/7192134359"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func timerStartStop(_ sender: Any)
    {
        //        startStopButton.isSelected = !startStopButton.isSelected
        //        startStopButton.isSelected ? timerPlay() : timerPause()
        
        if timerStatus
        {
            timerPause()
            print("타이머 상태: ", timerStatus)
            
        }
        else if count > 0
        {
            timerPlay()
            print("타이머 상태: ", timerStatus)
        }
        else
        {
            print("카운트를 시작하지 못하였습니다.")
        }
    }
    
    func timerPlay()
    {
        let startTime = Date()
        timerStatus = true
        startStopButton.setTitle(String(format: NSLocalizedString("일시중지", comment: "Pause")), for: .normal)
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true, block: { timer in
            let timeInterval = Date().timeIntervalSince(startTime)
            
            self.remainTime = self.count - timeInterval // 남은시간 계산
            self.elapsed = self.count - self.remainTime
            
            /** ceil(값) = 소수점 올림  floor(값) = 소수점 내림  trunc(값) = 소수점 버림  round(값) = 소수점 반올림 **/
            guard self.remainTime >= trunc(0) else
            {
                if(SettingTableCell.soundCheck == true)
                {
                    AudioServicesPlaySystemSound(1016) // "트윗" 소리발생
                    AudioServicesPlaySystemSound(4095) // 진동발생
                    print("Sound: ",SettingTableCell.soundCheck)
                }
                else if(SettingTableCell.soundCheck == false)
                {
                    print("Sound: ",SettingTableCell.soundCheck)
                }
                
                self.timerStop()
                self.reset()
                print("0초")
                return print("초기화 완료")
                
            }
            self.timeCal()
        })
    }
    
    func timerPause()
    {
        timerStatus = false
        count = count - elapsed // 일시정지 동안 카운트된 시간을 빼서 카운트를 줄인다
        timer.invalidate()
        startStopButton.setTitle(String(format: NSLocalizedString("시작", comment: "Start")), for: .normal)
        btnEnable()
        print("타이머 일시정지")
    }
    
    func timerStop()
    {
        timerStatus = false
        timer.invalidate()
        print("타이머 정지")
    }
    
    func timeCal()
    {
        hour = (Int)(fmod((remainTime/60/60), 100)) // 분을 12로 나누어 시를 구한다 * 100으로 설정해야 99시를 넘기지 않음.
        minute = (Int)(fmod((remainTime/60), 60)) // 초를 60으로 나누어 분을 구한다
        second = (Int)(fmod(remainTime, 60)) // 초를 구한다
        milliSecond = (Int)((remainTime - floor(remainTime))*1000)
        
        hourLabel.text = String(format: "%02d", hour)
        minLabel.text = String(format: "%02d", minute)
        secLabel.text = String(format: "%02d", second)
        milliSecLabel.text = String(format: "%03d", milliSecond)
        
        print("hour time:", hour)
        print("min time:", minute)
        print("sec time:", second)
        print("millisec time:", milliSecond)
        print("remainTime:", remainTime)
        print("경과시간:", elapsed)
        print("남은 카운트:", count)
        
        btnDisable() // 타이머 작동중 버튼 비활성화
        
    }
    
    func reset() // 초기화 함수 선언
    {
        timerStop()
        count = 0
        remainTime = 0
        elapsed = 0
        self.startStopButton.setTitle(String(format: NSLocalizedString("시작", comment: "Start")), for: .normal)
        
        hour = 0
        minute = 0
        second = 0
        milliSecond = 0
        
        hourLabel.text = "00"
        minLabel.text = "00"
        secLabel.text = "00"
        milliSecLabel.text = "000"
        print("초기화 남은 카운트:", count)
        
        btnEnable()
        
    }
    
    @IBAction func resetButton(_ sender: Any)
    {
        reset() //초기화 함수 호출
        print("초기화 되었습니다.")
        
    }
    
    func countLabel()
    {
        /*        3600==1시간        60==1분        1==1초        0.001==1밀리초        */
        hourLabel.text = String(format: "%02d", (Int)(fmod((count/60/60), 100)))
        minLabel.text = String(format: "%02d", (Int)(fmod((count/60), 60)))
        secLabel.text = String(format: "%02d", (Int)(fmod(count, 60)))
        milliSecLabel.text = String(format: "%03d", (Int)((count - floor(count))*1001)) //1001을 곱해줘야 밀리초가 정상표시됨.
        
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
    
    func btnEffect() /* 버튼을 누를때 발생하는 효과 */
    {
        if(SettingTableCell.vibrationCheck == true)
        {
            print("진동: ",SettingTableCell.vibrationCheck)
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred() // 탭틱 엔진이 있는 경우만 작동, 진동세기 강하게
            
        } else {
            print("진동: ",SettingTableCell.vibrationCheck)
        }
        //AudioServicesPlaySystemSound(1016) // 소리발생
    }
    
    // MARK: - Push 알림 관련
    func timerNoti()
    {
        let notificationCenter = NotificationCenter.default
        //         백그라운드 상태
        notificationCenter.addObserver(self, selector: #selector(backgroudTimer), name: UIApplication.willResignActiveNotification, object: nil)
        //         포그라운드 상태
        notificationCenter.addObserver(self, selector: #selector(foregroundTimer), name: UIApplication.willEnterForegroundNotification, object: nil)
        
    }
    
    func sendNotification()
    {
        NotificationCenter.default.post(name: Notification.Name("showPage"), object: nil, userInfo: ["index": 0]) // 푸시 알림 클릭 시 타이머 뷰로 이동함
        //        notiContent.title = String(format: NSLocalizedString("밀리초 타이머", comment: "Milliseccond Timer")) //appName(한글로만 나옴)
        notiContent.subtitle = String(format: NSLocalizedString("타이머 완료", comment: "Timer done"))
        notiContent.body = String(format: NSLocalizedString("0초가 되었습니다. 타이머를 다시 작동하려면 알림을 탭하세요!", comment: ""))
        notiContent.badge = 1
        notiContent.sound = UNNotificationSound.default
        notiContent.userInfo = ["Timer": "done"] // 푸시 받을 떄 오는 데이터
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: count, repeats: false) // 알림 발생 시기
        let identifier = "timerEnd" // 알림 고유 이름
        let request = UNNotificationRequest(identifier: identifier, content: notiContent, trigger: trigger) // 알림 결과
        notiCenter.add(request) { (error) in
            if let err = error {
                print("노티피케이션 알림 오류: ", err.localizedDescription)
            }
            else{
                print("노티피케이션 푸시알림 성공")
            }
        }
    }
    
    // 알림 제거 메소드
    func removeAllNotifications()
    {
        notiCenter.removeAllDeliveredNotifications()
        notiCenter.removeAllPendingNotificationRequests()
    }
    
    @objc func backgroudTimer()
    {
        print("백그라운드 타이머 작동")
        
        if timerStatus == true
        {
            timerStop()
            timerStatus = true
            backgroudTime = Date()
            
            print("백그라운드 남은 시간" , remainTime)
            print("타이머 상태: ", timerStatus)
        
            sendNotification()
        }
        else
        {
            timerStop()
            removeAllNotifications()
            print("타이머 상태: ", timerStatus)
        }
    }
    
    @objc func foregroundTimer()
    {
        
        print("포그라운드 타이머 작동")
        print("타이머 상태: ", timerStatus)
        guard let startTime = backgroudTime else { return}
        let timeInterval = Date().timeIntervalSince(startTime)
        
        DispatchQueue.main.async { [weak self] in
            
            if self?.timerStatus == true
            {
                self?.timeIntervalBackground(timeInterval)
                self?.timerPlay()
            }
            else
            {
                self?.timerStop()
            }
        }
    }
    
    func timeIntervalBackground(_ interval: Double)
    {
        count = remainTime - interval
        print("백그라운드 남은 시간: ", remainTime)
        if count < 0
        {
            reset()
        }
    }
    
    func upAlertError()
    {
        let alert = UIAlertController(title: String(format: NSLocalizedString("경고", comment: "Warning")), message: String(format: NSLocalizedString("타이머는 99시까지만 설정가능합니다.(설정할 수 있는 최대 시간값을 넘겼습니다)", comment: "")), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
    }
    
    func downAlertError ()
    {
        let alert = UIAlertController(title: String(format: NSLocalizedString("오류!", comment: "Error")), message: String(format: NSLocalizedString("시간이 충분히 남아 있지 않아 시간을 감소할 수 없습니다.", comment: "Time is no")), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: String(format: NSLocalizedString("확인", comment: "OK")), style: .destructive))
        present(alert, animated: true, completion: nil)
    }
    
    
    func btnEnable() // 증감 버튼 및 시간레이블 활성화 메소드
    {
        hourUpButton.isEnabled = true
        hourDownButton.isEnabled = true
        minUpButton.isEnabled = true
        minDownButton.isEnabled = true
        secUpButton.isEnabled = true
        secDownButton.isEnabled = true
        millisecUpButton.isEnabled = true
        millisecDownButton.isEnabled = true
        
        let hourTap = UITapGestureRecognizer(target: self, action: #selector(MainTimer.HourLabeltap))
        hourLabel.addGestureRecognizer(hourTap)
        hourLabel.isUserInteractionEnabled = true
        let minTap = UITapGestureRecognizer(target: self, action: #selector(MainTimer.MinLabeltap))
        minLabel.addGestureRecognizer(minTap)
        minLabel.isUserInteractionEnabled = true
        let secTap = UITapGestureRecognizer(target: self, action: #selector(MainTimer.SecLabeltap))
        secLabel.addGestureRecognizer(secTap)
        secLabel.isUserInteractionEnabled = true
        let milliSecTap = UITapGestureRecognizer(target: self, action: #selector(MainTimer.MillisecLabeltap))
        milliSecLabel.addGestureRecognizer(milliSecTap)
        milliSecLabel.isUserInteractionEnabled = true
        
    }
    
    func btnDisable() //증감 버튼 및 시간레이블 비활성화 메소드
    {
        hourUpButton.isEnabled = false
        hourDownButton.isEnabled = false
        minUpButton.isEnabled = false
        minDownButton.isEnabled = false
        secUpButton.isEnabled = false
        secDownButton.isEnabled = false
        millisecUpButton.isEnabled = false
        millisecDownButton.isEnabled = false
        
        hourLabel.isUserInteractionEnabled = false
        minLabel.isUserInteractionEnabled = false
        secLabel.isUserInteractionEnabled = false
        milliSecLabel.isUserInteractionEnabled = false
        
    }
    
    @IBAction func millisecUp(_ sender : Any)
    {
        if(count < 356400)
        {
            count += 0.001
            btnEffect()
            countLabel()
        }
        
        else
        {
            upAlertError()
        }
    }
    
    @IBAction func millisecDown(_ sender : Any)
    {
        if count > 0.000
        {
            count -= 0.001
            btnEffect()
            print(count,"m시간을 감소 하였습니다")
            countLabel()
        }
        else
        {
            downAlertError()
        }
    }
    
    @IBAction func secUp(_ sender:Any)
    {
        if(count < 356400)
        {
            count += 1
            countLabel()
            btnEffect()
        }
        else
        {
            upAlertError()
        }
        
    }
    
    @IBAction func secDown( _ sender : Any)
    {
        if count > 0
        {
            count -= 1
            btnEffect()
            print(count, "s시간을 감소 하였습니다")
            countLabel()
        }
        else
        {
            downAlertError()
            print("초가 충분히 남아 있지 않아 시간을 감소할 수 없습니다.")
            print(count, "시간이 저장되어있다.")
        }
    }
    
    @IBAction func minUp(_ sender : Any)
    {
        if(count < 356400)
        {
            count += 60
            btnEffect()
            countLabel()
        }
        
        else
        {
            upAlertError()
        }
    }
    
    @IBAction func minDown(_ sender : Any)
    {
        if count > 59
        {
            count -= 60
            btnEffect()
            print(count, "분시간이 감소 하였습니다")
            countLabel()
        }
        else
        {
            downAlertError()
            print("분 시간이 충분히 남아 있지 않아 시간을 감소할 수 없습니다.")
            print(count, "시간이 저장되어있다.")
        }
    }
    
    @IBAction func hourUp(_ sender : Any)
    {
        if(count < 356400) //99시간으로 제한(3자리 시간적용시 레이아웃깨짐)
        {
            count += 3600
            countLabel()
            btnEffect()
        }
        else
        {
            upAlertError()
        }
    }
    
    @IBAction func hourDown(_ sender : Any)
    {
        if count > 3599 {
            count -= 3600
            btnEffect()
            countLabel()
        }
        else
        {
            downAlertError()
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
    
    func Hourinput()
    {
        let alert = UIAlertController(title: String(format: NSLocalizedString("타이머 시간을 입력하세요", comment: "Enter the timer hours")), message: String(format: NSLocalizedString("1시간은 1을 입력하면됩니다. 예) 99입력→99시간", comment: "")), preferredStyle: .alert)
        let ok = UIAlertAction(title: String(format: NSLocalizedString("확인", comment: "OK")), style: .default) { (_) in
            print("알림창에서 확인을 눌렀습니다.")
            if let txt = alert.textFields?.first {
                if txt.text?.isEmpty != true { // https://jeonyeohun.tistory.com/87 타입추론 형 변환
                    print("입력값: ", txt.text!)
                    if let inputcount = Int(txt.text!){ // https://developer.apple.com/forums/thread/100634 숫자 판별
                        if inputcount < 356400 && txt.text!.count < 3 {
                            self.count = Double(inputcount * 3600) + self.count
                            self.countLabel()
                            print("입력한숫자값:", inputcount)
                            print(type(of: inputcount))
                        } else {
                            self.upAlertError()
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
            textField.textContentType = .creditCardNumber // 숫자 키패드
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
                            self.countLabel()
                            print("입력한숫자값:", inputcount)
                            print(type(of: inputcount))
                        } else {
                            self.upAlertError()
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
            textField.textContentType = .creditCardNumber
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
                            self.countLabel()
                            print("입력한숫자값:", inputcount)
                            print(type(of: inputcount))
                        } else {
                            self.upAlertError()
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
            textField.textContentType = .creditCardNumber
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
                            self.countLabel()
                            print("입력한숫자값:", inputcount)
                            print(type(of: inputcount))
                        } else {
                            self.upAlertError()
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
            textField.textContentType = .creditCardNumber
            textField.keyboardType = .numberPad
            
        }
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    private func TipLabel()
    {
        tipLabel.text = String(format: NSLocalizedString("빠르게 시간을 변경하려면 타이머 숫자를 탭하세요.\n시:분:초:밀리초", comment: ""))
    }
}
