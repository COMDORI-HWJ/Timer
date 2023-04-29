//
//  SettingTableCell.swift
//  Timer
//
//  Created by WONJI HA on 2021/10/22.
//

/* Reference
 https://philosopher-chan.tistory.com/1032 테이블 셀 클릭 이벤트 처리
 https://stackoverflow.com/questions/37558333/select-cell-in-tableview-section 테이블 섹션 구분
 */

import Foundation
import UIKit
import AVFoundation //소리, 진동


class SettingTableCell:UITableViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        SoundSwitch.isOn = UserDefaults.standard.bool(forKey: "SoundSwitchState") // UserDefaults 사용하여 데이터 저장 https://zeddios.tistory.com/107
        VibrationSwitch.isOn = UserDefaults.standard.bool(forKey: "VibrationSwitchState")

        appver()
    }

    @IBOutlet var SoundSwitch: UISwitch!
    @IBOutlet var VibrationSwitch: UISwitch!
    @IBOutlet weak var Ver: UILabel!

    static var soundCheck : Bool = true  // 소리확인 변수 *static 프로퍼티를 사용해야 값이 수정된다. https://babbab2.tistory.com/119?category=828998
    static var vibrationCheck : Bool = true


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


    var version: String? {
        guard let dictionary = Bundle.main.infoDictionary,
            let version = dictionary["CFBundleShortVersionString"] as? String,
            let build = dictionary["CFBundleVersion"] as? String else {return nil}

        let versionAndBuild: String = String(format: NSLocalizedString("앱 버전 : ", comment: "App Version"))+"\(version)"
        return versionAndBuild
    }

    func appver ()
    {
        print(version!)
        Ver.text = version
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("테이블셀을 클릭 했습니다")
        print(indexPath.section,"섹션의", indexPath.row , "행입니다.")
        
        if(indexPath.section == 1 && indexPath.row == 2){
            print("1번째 섹션의 2번째 행 클릭발생")
        }
    }


}
