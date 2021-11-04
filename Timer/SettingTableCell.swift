//
//  SettingTableCell.swift
//  Timer
//
//  Created by WONJI HA on 2021/10/22.
//

import Foundation
import UIKit
import AVFoundation //소리, 진동


class SettingTableCell:UITableViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        SoundSwitch.isOn = UserDefaults.standard.bool(forKey: "SoundSwitchState") // UserDefaults 사용하여 데이터 저장 https://zeddios.tistory.com/107
        VibrationSwitch.isOn = UserDefaults.standard.bool(forKey: "VibrationSwitchState")

    }
    
    @IBOutlet var SoundSwitch: UISwitch!
    @IBOutlet var VibrationSwitch: UISwitch!
    
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
    
}
