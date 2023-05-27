//
//  SettingTableCell.swift
//  Timer
//
//  Created by WONJI HA on 2021/10/22.
//

/* Reference
 https://philosopher-chan.tistory.com/1032 테이블 셀 클릭 이벤트 처리
 https://stackoverflow.com/questions/37558333/select-cell-in-tableview-section 테이블 섹션 구분
 https://sweetdev.tistory.com/105 셀 선택시 바로 deselect 시켜버리기
 https://velog.io/@minji0801/iOS-Swift-iOS-%EA%B8%B0%EA%B8%B0%EC%97%90%EC%84%9C-Mail-%EC%95%B1-%EC%9D%B4%EC%9A%A9%ED%95%B4%EC%84%9C-%EC%9D%B4%EB%A9%94%EC%9D%BC-%EB%B3%B4%EB%82%B4%EB%8A%94-%EB%B0%A9%EB%B2%95 메일 보내기
 https://borabong.tistory.com/6 메일컨트롤러 dismiss
 */

import Foundation
import UIKit
import AVFoundation //소리, 진동
import MessageUI


class SettingTableCell:UITableViewController, MFMailComposeViewControllerDelegate{
    
    @IBOutlet var SoundSwitch: UISwitch!
    @IBOutlet var VibrationSwitch: UISwitch!
    @IBOutlet weak var Ver: UILabel!
    
    static var soundCheck : Bool = true  // 소리확인 변수 *static 프로퍼티를 사용해야 값이 수정된다. https://babbab2.tistory.com/119?category=828998
    static var vibrationCheck : Bool = true
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        SoundSwitch.isOn = UserDefaults.standard.bool(forKey: "SoundSwitchState") // UserDefaults 사용하여 데이터 저장 https://zeddios.tistory.com/107
        VibrationSwitch.isOn = UserDefaults.standard.bool(forKey: "VibrationSwitchState")

        appver()
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            self.dismiss(animated: true, completion: nil)
        }
        guard let info = storyboard?.instantiateViewController(identifier: "Info") as? Info else { return }
        let navigationController = UINavigationController(rootViewController: info)
        present(navigationController, animated: true)
    }


    @IBAction func SoundAlert(_ sender: UISwitch) {
        UserDefaults.standard.set(SoundSwitch.isOn, forKey: "SoundSwitchState")
        if(sender.isOn)
        {
            SettingTableCell.soundCheck = true
            AudioServicesPlaySystemSound(1016) // "트윗" 소리
            AudioServicesPlaySystemSound(4095) // 진동
            print("소리확인 결과: ",SettingTableCell.soundCheck)
        }
        else
        {
            SettingTableCell.soundCheck = false
            print("소리확인 결과: ",SettingTableCell.soundCheck)
        }
    }

    @IBAction func VibrationEffect(_ sender: Any){
        UserDefaults.standard.set(VibrationSwitch.isOn, forKey: "VibrationSwitchState")
        if(VibrationSwitch.isOn)
        {
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            SettingTableCell.vibrationCheck = true
            print("진동체크 결과: ", SettingTableCell.vibrationCheck)

        }
        else
        {
            SettingTableCell.vibrationCheck = false
            print("진동체크 결과: ", SettingTableCell.vibrationCheck)
        }
    }


    func version() -> String {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String else { return "" }
        return version
    }

    func appver ()
    {
        print(version())
        Ver.text =  String(format: NSLocalizedString("앱 버전 : ", comment: "App Version"))+"\(self.version())"
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
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell()
//        cell.selectionStyle = .none
//    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("테이블셀을 클릭 했습니다", indexPath.section,"섹션의", indexPath.row , "행입니다.")
        tableView.deselectRow(at: indexPath, animated: true) // 셀 선택후 바로 선택해제 하기
        if(indexPath.section == 1 && indexPath.row == 0){
//           let infoVC = self.storyboard?.instantiateViewController(withIdentifier: "Info")
//            self.navigationController?.pushViewController(infoVC!, animated: true)
            
//            let vcName = self.storyboard?.instantiateViewController(withIdentifier: "Info")
//                    vcName?.modalPresentationStyle = .fullScreen //전체화면으로 보이게 설정
//                    vcName?.modalTransitionStyle = .crossDissolve //전환 애니메이션 설정
//                    self.present(vcName!, animated: true, completion: nil)
            
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "Info")
            self.navigationController?.pushViewController(viewController!, animated: true)
        }
        
        if(indexPath.section == 1 && indexPath.row == 0) {
            
            guard let tutorial = self.storyboard?.instantiateViewController(withIdentifier: "TutorialVC") as? Tutorial else { return }
            tutorial.modalTransitionStyle = .flipHorizontal // 화면 전환 애니메이션 설정
            tutorial.modalPresentationStyle = .popover // 전환된 화면이 보여지는 방법 설정
            self.present(tutorial, animated: true, completion: nil)

        }
        
        if(indexPath.section == 1 && indexPath.row == 3) {
            
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
                
                ┈┈┈┈┈┈┈✄┈┈┈┈┈┈┈
                개선사항 및 아이디어 제보 : ☛ 이 문장을 지우고 자유롭게 적어주시면 감사하겠습니다.
                
                문의해 주셔서 감사합니다. 🙇🏼‍♂️
                """
                
                composeViewController.setToRecipients(["02145s1@gmail.com"])
                composeViewController.setSubject("[iOS 타이머 앱] 문의사항")
                composeViewController.setMessageBody(msgBody, isHTML: false)
                self.present(composeViewController, animated: true, completion: nil)

            } else {
                print("send Mail Fail")
                let sendMailErrorAlert = UIAlertController(title: "문의사항 보내기 오류", message: "현재 메일앱이 설치되어 있지 않거나 메일앱 설정이 되어 있지 않습니다. App Store에서 Apple Mail앱 다운로드 또는 메일앱 설정을 확인해 주시기를 바랍니다.", preferredStyle: .alert)
                let mailInstall = UIAlertAction(title: "메일앱 다운로드", style: .default) { _ in
                    if let url = URL(string: "https://apps.apple.com/kr/app/mail/id1108187098"), UIApplication.shared.canOpenURL(url) {
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        } else {
                            UIApplication.shared.openURL(url)
                        }
                    }
                }
                let cancelMailInstall = UIAlertAction(title: "취소", style: .destructive, handler: nil)
                sendMailErrorAlert.addAction(mailInstall)
                sendMailErrorAlert.addAction(cancelMailInstall)
                self.present(sendMailErrorAlert, animated: true, completion: nil)
            }
        }
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil) // 메일 보내기 창 dismiss
    }
}

