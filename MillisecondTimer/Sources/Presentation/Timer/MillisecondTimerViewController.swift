//  
//  MillisecondTimerViewController.swift
//  MillisecondTimer
//
//  Created by Wonji Ha on 2021/12/08.
//

import UIKit
import AVFoundation
import UserNotifications
import SystemConfiguration

class MillisecondTimerViewController: UIViewController, MillisecondTimerDelegate {
    
    @IBOutlet weak var adView: UIView!
    
    @IBOutlet weak var tipLabel: UILabel!
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
    
    var hour = 0, minute = 0, second = 0, milliSecond = 0

    var timerStatus : Bool = false // 타이머 상태
    var count : Double = 0 // 타이머 시간
    var remainTime : Double = 0 // 남은 시간
    var elapsed : Double = 0 // 경과시간

    
    private let viewModel = MillisecondTimerViewModel()
    private let adsManager = AdsManager()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        adsManager.rootViewController = self
        viewModel.timerDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIButton.appearance().isExclusiveTouch = true // 버튼 멀티터치 막기
        viewModel.addTimerPushNotification()
        viewModel.timerTextCallback = { [weak self] in
            self?.timeLabelText()
        }
        buttonEnable()
        TipLabel()
        self.navigationController?.navigationBar.topItem?.title="AD" //뷰 제목
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func timerStartStopButton(_ sender: Any) {
        if viewModel.mTimer.status {
            viewModel.timerPause()
            startStopButton.setTitle(ButtonType.start.name, for: .normal)
            buttonEnable()
            print("타이머 상태: ", viewModel.mTimer.status)
        }
        else if viewModel.mTimer.count > 0 {
            viewModel.timerPlay(timeUpdate: timeLabelText, timerReset: timerReset)
            startStopButton.setTitle(ButtonType.pause.name, for: .normal)
            viewModel.createTimerNotification()
            buttonDisable()
            print("타이머 상태: ", viewModel.mTimer.status)
        }
        else {
            print("카운트를 시작하지 못하였습니다.")
        }
    }
    
    func timerReset() {
        hourLabel.text = "00"
        minLabel.text = "00"
        secLabel.text = "00"
        milliSecLabel.text = "000"
        startStopButton.setTitle(ButtonType.start.name, for: .normal)
        buttonEnable()
        print("초기화 완료")
    }
    
    func timerDidReset() {
        timerReset()
    }
    
    @IBAction func resetButton(_ sender: Any) {
        timerReset()
        viewModel.resetTimer()
        print("초기화 되었습니다.")
    }
    
    func timeLabelText() {
        hourLabel.text = viewModel.hourText
        minLabel.text = viewModel.minuteText
        secLabel.text = viewModel.secondText
        milliSecLabel.text = viewModel.millisecondText
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
    
    func buttonEffectTapped() /* 버튼을 누를때 발생하는 효과 */
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
    
    func buttonEnable() {
        hourUpButton.isEnabled = true
        hourDownButton.isEnabled = true
        minUpButton.isEnabled = true
        minDownButton.isEnabled = true
        secUpButton.isEnabled = true
        secDownButton.isEnabled = true
        millisecUpButton.isEnabled = true
        millisecDownButton.isEnabled = true
        
        let hourTap = UITapGestureRecognizer(target: self, action: #selector(MillisecondTimerViewController.HourLabeltap))
        hourLabel.addGestureRecognizer(hourTap)
        hourLabel.isUserInteractionEnabled = true
        let minTap = UITapGestureRecognizer(target: self, action: #selector(MillisecondTimerViewController.MinLabeltap))
        minLabel.addGestureRecognizer(minTap)
        minLabel.isUserInteractionEnabled = true
        let secTap = UITapGestureRecognizer(target: self, action: #selector(MillisecondTimerViewController.SecLabeltap))
        secLabel.addGestureRecognizer(secTap)
        secLabel.isUserInteractionEnabled = true
        let milliSecTap = UITapGestureRecognizer(target: self, action: #selector(MillisecondTimerViewController.MillisecLabeltap))
        milliSecLabel.addGestureRecognizer(milliSecTap)
        milliSecLabel.isUserInteractionEnabled = true
    }
    
    func buttonDisable() {
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
    
    
    // MARK: - Push 알림 관련
//    func timerNoti()
//    {
//        let notificationCenter = NotificationCenter.default
//        // 백그라운드 상태
//        notificationCenter.addObserver(self, selector: #selector(backgroudTimer), name: UIApplication.willResignActiveNotification, object: nil)
//        // 포그라운드 상태
//        notificationCenter.addObserver(self, selector: #selector(foregroundTimer), name: UIApplication.willEnterForegroundNotification, object: nil)
//        
//    }
    
    
//    @objc func backgroudTimer() {
//        print("백그라운드 타이머 작동")
//        
//        if viewModel.mTimer.status == true {
//            timerStop()
////            //            viewModel.mTimer.status = true
////            viewModel.mTimer.backgroudTime = Date()
////            
////            print("백그라운드 남은 시간" , viewModel.mTimer.remainTime)
////            print("타이머 상태: ", viewModel.mTimer.status)
////            
////            sendNotification()
//            viewModel.backgroundTimer()
//            viewModel.createTimerNotification()
//        }
//        else {
//            timerStop()
////            removeAllNotifications()
////            print("타이머 상태: ", timerStatus)
//            viewModel.backgroundTimer()
//        }
//    }
//    
//    @objc
//    func foregroundTimer() {
//        
//        print("포그라운드 타이머 작동")
//        print("타이머 상태: ", viewModel.mTimer.status)
//        guard let startTime = viewModel.mTimer.backgroudTime else { return }
//        let timeInterval = Date().timeIntervalSince(startTime)
//        
//        DispatchQueue.main.async { [self] in
//            
//            if viewModel.mTimer.status == true {
//                //                self?.timeIntervalBackground(timeInterval)
//                viewModel.backgroundTimeInterval(timeInterval)
//                timerPlay()
//            }
//            else {
//                timerStop()
//                reset()
//            }
//        }
//    }
    
    private func presentAlert(title: String? = nil, message: String, actions: [UIAlertAction], textField: ((UITextField) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let configureTextField = textField {
            alertController.addTextField(configurationHandler: configureTextField)
        }
        actions.forEach { alertController.addAction($0) }
        present(alertController, animated: true, completion: nil)
        }
    
    func addTimerAlertError() {
        let action = UIAlertAction(title: String(format: NSLocalizedString("확인", comment: "OK")), style: .default)
        presentAlert(title: String(format: NSLocalizedString("오류!", comment: "Error")), message: String(format: NSLocalizedString("타이머는 99시까지만 설정가능합니다.(설정할 수 있는 최대 시간값을 넘겼습니다)", comment: "")), actions: [action])
    }
    
    func subtractTimerAlertError () {
        let action = UIAlertAction(title: String(format: NSLocalizedString("확인", comment: "OK")), style: .destructive)
        presentAlert(title: String(format: NSLocalizedString("오류!", comment: "Error")), message: String(format: NSLocalizedString("시간이 충분히 남아 있지 않아 시간을 감소할 수 없습니다.", comment: "Time is no")), actions: [action])
    }
    
    private func timerCountUpdate() {
        timeLabelText()
        buttonEffectTapped()
    }
    
    @IBAction private func addMillisecondCountButton(_ sender : Any) {
        if viewModel.mTimer.count < viewModel.maxCount {
            viewModel.addTimerCount(unit: .millisecond)
            timerCountUpdate()
        } else {
            addTimerAlertError()
        }
    }
    
    @IBAction private func subtractMillisecondCountButton(_ sender : Any) {
        if viewModel.mTimer.count > viewModel.minimumCount {
            viewModel.subtractTimerCount(unit: .millisecond)
            timerCountUpdate()
        } else {
            subtractTimerAlertError()
        }
    }
    
    @IBAction private func addSecondCountButton(_ sender:Any) {
        if viewModel.mTimer.count < viewModel.maxCount {
            viewModel.addTimerCount(unit: .second)
            timerCountUpdate()
        } else {
            addTimerAlertError()
        }
    }
    
    @IBAction private func subtractSecondCountButton( _ sender : Any) {
        if viewModel.mTimer.count > 0.9999 {
            viewModel.subtractTimerCount(unit: .second)
            timerCountUpdate()
        } else {
            subtractTimerAlertError()
        }
    }
    
    @IBAction func addMinuteCountButton(_ sender : Any) {
        if viewModel.mTimer.count < viewModel.maxCount {
            viewModel.addTimerCount(unit: .minute)
            timerCountUpdate()
        } else {
            addTimerAlertError()
        }
    }
    
    @IBAction private func subtractMinuteCountButton(_ sender : Any) {
        if viewModel.mTimer.count > 59 {
            viewModel.subtractTimerCount(unit: .minute)
            timerCountUpdate()
        } else {
            subtractTimerAlertError()
        }
    }
    
    @IBAction private func addHourCountButton(_ sender : Any) {
        if viewModel.mTimer.count < viewModel.maxCount {
            viewModel.addTimerCount(unit: .hour)
            timerCountUpdate()
        } else {
            addTimerAlertError()
        }
    }
    
    @IBAction private func subtractHourCountButton(_ sender : Any) {
        if viewModel.mTimer.count > 3599 {
            viewModel.subtractTimerCount(unit: .hour)
            timerCountUpdate()
        } else {
            subtractTimerAlertError()
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
    
    func Hourinput() {
        let alertController = UIAlertController(title: String(format: NSLocalizedString("타이머 시간을 입력하세요", comment: "Enter the timer hours")), message: String(format: NSLocalizedString("1시간은 1을 입력하면됩니다. 예) 99입력→99시간", comment: "")), preferredStyle: .alert)
        let ok = UIAlertAction(title: String(format: NSLocalizedString("확인", comment: "OK")), style: .default) { (_) in
            print("알림창에서 확인을 눌렀습니다.")
            if let txt = alertController.textFields?.first {
                if txt.text?.isEmpty != true { // https://jeonyeohun.tistory.com/87 타입추론 형 변환
                    print("입력값: ", txt.text!)
                    if let inputcount = Int(txt.text!){ // https://developer.apple.com/forums/thread/100634 숫자 판별
                        if inputcount < 356400 && txt.text!.count < 3 {
                            self.count = Double(inputcount * 3600) + self.count
                            self.countLabel()
                            print("입력한숫자값:", inputcount)
                            print(type(of: inputcount))
                        } else {
                            self.addTimerAlertError()
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
        alertController.addTextField() { (textField) in
            textField.placeholder = String(format: NSLocalizedString("이곳에 시간을 입력하세요.", comment: ""))
            textField.textContentType = .creditCardNumber // 숫자 키패드
            textField.keyboardType = .numberPad
        }
        alertController.addAction(ok)
        alertController.addAction(cancel)
        present(alertController, animated: true)
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
                            self.addTimerAlertError()
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
                            self.addTimerAlertError()
                            print("99시간이 넘어간다.")
                        }
                    }
                    else {
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
                            self.addTimerAlertError()
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

extension MillisecondTimerViewController: AdSimpleBannerPowered {
    func addBannerToAdsPlaceholder(_ banner: UIView) {
        banner.translatesAutoresizingMaskIntoConstraints = false
        adView.addSubview(banner)
        banner.topAnchor.constraint(equalTo: adView.topAnchor).isActive = true
        banner.heightAnchor.constraint(equalTo: adView.heightAnchor).isActive = true
        banner.leadingAnchor.constraint(equalTo: adView.leadingAnchor).isActive = true
        banner.trailingAnchor.constraint(equalTo: adView.trailingAnchor).isActive = true
    }
}
