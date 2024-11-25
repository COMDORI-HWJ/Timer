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
    
    func buttonEffectTapped() { // 버튼을 누를때 발생하는 효과
        if(SettingTableCell.vibrationCheck == true) {
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
        
        let hourTap = UITapGestureRecognizer(target: self, action: #selector(MillisecondTimerViewController.hourLabeltap))
        hourLabel.addGestureRecognizer(hourTap)
        hourLabel.isUserInteractionEnabled = true
        let minTap = UITapGestureRecognizer(target: self, action: #selector(MillisecondTimerViewController.minuteLabeltap))
        minLabel.addGestureRecognizer(minTap)
        minLabel.isUserInteractionEnabled = true
        let secTap = UITapGestureRecognizer(target: self, action: #selector(MillisecondTimerViewController.secondLabeltap))
        secLabel.addGestureRecognizer(secTap)
        secLabel.isUserInteractionEnabled = true
        let milliSecTap = UITapGestureRecognizer(target: self, action: #selector(MillisecondTimerViewController.millisecondLabeltap))
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
    
    @objc func hourLabeltap(sender:UITapGestureRecognizer) {
        print("HourLabel tap working")
        presetHourInputAlert()
    }
    
    @objc func minuteLabeltap(sender:UITapGestureRecognizer) {
        print("MinLabel tap working")
        presentMinuteInputAlert()
    }
    
    @objc func secondLabeltap(sender:UITapGestureRecognizer) {
        print("SecLabel tap working")
        presentSecondInputAlert()
    }
    
    @objc func millisecondLabeltap(sender:UITapGestureRecognizer) {
        print("MillisecLabel tap working")
        presentMillisecondInputAlert()
    }
    
    private func presentTimeInputAlert(title: String, message: String, unit: TimeUnit) {
        let alertController = UIAlertController(title: NSLocalizedString(title, comment: ""), message: NSLocalizedString(message, comment: ""), preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("확인", comment: "OK"), style: .default) { [weak self] _ in
            self?.handleTimeInput(alertController.textFields?.first?.text, unit: unit)
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("취소", comment: "Cancel"), style: .cancel)
        
        alertController.addTextField { textField in
            textField.placeholder = NSLocalizedString("이곳에 \(unit.description)을 입력하세요.", comment: "")
            textField.keyboardType = .numberPad
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    private func handleTimeInput(_ input: String?, unit: TimeUnit) {
        guard let inputText = input, !inputText.isEmpty else {
            print("입력값이 없습니다.")
            return
        }
        
        guard let inputValue = Double(inputText) else {
            presentErrorAlert(message: "시간은 숫자만 입력 가능합니다.")
            return
        }
        
        if inputValue < 356400 && (unit != .hour || inputText.count < 3) {
            let seconds = unit.toSeconds(inputValue)
            viewModel.addSecondsToTimer(seconds)
            timerCountUpdate()
            print("입력한 \(unit.description):", inputValue)
        } else {
            addTimerAlertError()
            print("99시간이 넘어갑니다.")
        }
    }
    
    private func presentErrorAlert(message: String) {
        let alert = UIAlertController(title: NSLocalizedString("오류", comment: ""), message: NSLocalizedString(message, comment: ""), preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("확인", comment: "OK"), style: .destructive)
        alert.addAction(okAction)
        present(alert, animated: false)
    }
    
    private func presetHourInputAlert() {
        presentTimeInputAlert(title: "타이머 시간을 입력하세요", message: "1시간은 1을 입력하세요. 예) 99입력→99시간", unit: .hour)
    }
    
    private func presentMinuteInputAlert() {
        presentTimeInputAlert(title: "타이머 분을 입력하세요", message: "1분은 1을 입력하세요. 예) 33입력→33분", unit: .minute)
    }
    
    private func presentSecondInputAlert() {
        presentTimeInputAlert(title: "타이머 초를 입력하세요", message: "1초는 1을 입력하세요. 예) 55입력→55초", unit: .second)
    }
    
    private func presentMillisecondInputAlert() {
        presentTimeInputAlert(title: "타이머 밀리초를 입력하세요", message: "0.001초는 1을 입력하세요. \n예) 777입력→0.777밀리초", unit: .millisecond)
    }
    
    private func TipLabel() {
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
