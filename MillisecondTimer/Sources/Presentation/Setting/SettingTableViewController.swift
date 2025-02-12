//
//  SettingTableCell.swift
//  Timer
//
//  Created by WONJI HA on 2021/10/22.
//


import UIKit
import AVFoundation // 소리, 진동
import MessageUI
import StoreKit

class SettingTableViewController:UITableViewController, MFMailComposeViewControllerDelegate{
    
    @IBOutlet var soundSwitch: UISwitch!
    @IBOutlet var vibrationSwitch: UISwitch!
    
    static var soundCheck : Bool = true
    static var vibrationCheck : Bool = true
    
    let ud = UserDefaults.standard
    let vibrationKey = "vibrationKey"
    let soundKey = "soundKey"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            self.dismiss(animated: true, completion: nil)
        }
        
        guard let info = storyboard?.instantiateViewController(identifier: "Info") as? InfoViewController else { return }
        let navigationController = UINavigationController(rootViewController: info)
        present(navigationController, animated: true)
        
        ud.register(defaults: ["vibrationKey" : true])
        ud.register(defaults: ["soundKey" : true])
        
        vibrationSwitch.isOn = ud.bool(forKey: vibrationKey)
        soundSwitch.isOn = ud.bool(forKey: soundKey)
    }
    
    @IBAction func sound(_ sender: UISwitch) {
        if(sender.isOn) {
            SettingTableViewController.soundCheck = true
            AudioServicesPlaySystemSound(1016) // "트윗" 소리
            AudioServicesPlaySystemSound(4095) // 진동
            print("소리확인 결과: ",SettingTableViewController.soundCheck)
        } else {
            SettingTableViewController.soundCheck = false
            print("소리확인 결과: ",SettingTableViewController.soundCheck)
        }
        ud.set(soundSwitch.isOn, forKey: soundKey)
    }
    
    @IBAction func vibration(_ sender: Any) {
        
        if(vibrationSwitch.isOn) {
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            SettingTableViewController.vibrationCheck = true
            print("진동체크 결과: ", SettingTableViewController.vibrationCheck)
        } else {
            SettingTableViewController.vibrationCheck = false
            print("진동체크 결과: ", SettingTableViewController.vibrationCheck)
        }
        ud.set(vibrationSwitch.isOn, forKey: vibrationKey)
    }
    
    func version() -> String {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String else { return "" }
        return version
    }
    
    // Device Identifier 찾기
    func getDeviceIdentifier() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return String(format: NSLocalizedString("기능 설정", comment: "기능설정"))
        }
        if section == 1 {
            return String(format: NSLocalizedString("지원", comment: "지원"))
        }
        return "Header \(section)"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("테이블셀을 클릭 했습니다", indexPath.section,"섹션의", indexPath.row , "행입니다.")
        tableView.deselectRow(at: indexPath, animated: true) // 셀 선택후 바로 선택해제 하기
        
        if(indexPath.section == 1 && indexPath.row == 0) {
            
            guard let tutorialViewController = self.storyboard?.instantiateViewController(withIdentifier: "TutorialViewController") as? TutorialViewController else { return }
            tutorialViewController.modalTransitionStyle = .flipHorizontal // 화면 전환 애니메이션 설정
            tutorialViewController.modalPresentationStyle = .popover // 전환된 화면이 보여지는 방법 설정
            self.present(tutorialViewController, animated: true, completion: nil)
            
        }
        
        if(indexPath.section == 1 && indexPath.row == 2) {
            
            if MFMailComposeViewController.canSendMail() {
                let composeViewController = MFMailComposeViewController()
                composeViewController.mailComposeDelegate = self
                
                let msgBody =
                """
                아이폰 모델 : \(self.getDeviceIdentifier())
                iOS 버전 : \(UIDevice.current.systemVersion)
                앱 버전 : \(version())
                ┈┈┈┈┈┈┈✄┈┈┈┈┈┈┈
                
                오류 및 버그 :  ☛ 이 문장을 지우고 버그, 오류 사항, 안 되는것 을 적어주시면 됩니다.
                
                Errors or Bugs : ☛ Remove this sentence and list the bugs, errors, and things that don't work.
                
                ┈┈┈┈┈┈┈✄┈┈┈┈┈┈┈
                개선사항 및 아이디어 제보 : ☛ 이 문장을 지우고 자유롭게 적어주시면 감사하겠습니다.
                
                Improvements and new features : ☛ If you need a new feature, remove this sentence and write it.
                
                문의해 주셔서 감사합니다. 🙇🏼‍♂️
                Thanks for feedback. 🙇🏼‍♂️
                """
                
                composeViewController.setToRecipients(["02145s1@gmail.com"])
                composeViewController.setSubject("[iOS 밀리초타이머 앱] 문의사항")
                composeViewController.setMessageBody(msgBody, isHTML: false)
                self.present(composeViewController, animated: true, completion: nil)
                
            } else {
                print("send Mail Fail")
                let sendMailErrorAlert = UIAlertController(title: String(format: NSLocalizedString("문의사항 보내기 오류", comment: "문의사항 보내기 오류")), message: String(format: NSLocalizedString("현재 메일앱이 설치되어 있지 않거나 메일앱 설정이 되어 있지 않습니다. App Store에서 Mail앱 다운로드 또는 메일앱 설정을 확인해 주시기를 바랍니다.", comment: "메일앱안내")), preferredStyle: .alert)
                let mailInstall = UIAlertAction(title: String(format: NSLocalizedString("메일앱 다운로드", comment: "메일앱 다운로드")), style: .default) { _ in
                    if let url = URL(string: "https://apps.apple.com/kr/app/mail/id1108187098"), UIApplication.shared.canOpenURL(url) {
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        } else {
                            UIApplication.shared.openURL(url)
                        }
                    }
                }
                let cancelMailInstall = UIAlertAction(title: String(format: NSLocalizedString("취소", comment: "취소")), style: .destructive, handler: nil)
                sendMailErrorAlert.addAction(mailInstall)
                sendMailErrorAlert.addAction(cancelMailInstall)
                self.present(sendMailErrorAlert, animated: true, completion: nil)
            }
        }
        
        if(indexPath.section == 1 && indexPath.row == 3) { // 앱스토어 리뷰 남기기 메소드
            if #available(iOS 14.0, *) {
                if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive
                }) as? UIWindowScene {
                    SKStoreReviewController.requestReview(in: scene)
                }
            } else {
                SKStoreReviewController.requestReview()
            }
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil) // 메일 보내기 창 dismiss
    }
}
