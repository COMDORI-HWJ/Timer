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

    }
    
    @IBOutlet var SoundSwitch: UISwitch!
    @IBOutlet var VibrationSwitch: UISwitch!
    
    static var soundCheck : Bool = true  //소리확인 변수 *static 프로퍼티를 사용해야 값이 수정된다. https://babbab2.tistory.com/119?category=828998
    static var vibrationCheck : Bool = true
    
    
    @IBAction func SoundAlert(_ sender: UISwitch) {
        if(sender.isOn)
        {
            SettingTableCell.soundCheck = true
            AudioServicesPlaySystemSound(1016) // "트윗" 소리
            print("소리확인 결과: ",SettingTableCell.soundCheck)
           

        }
        else
        {
            SettingTableCell.soundCheck = false
            print("소리확인 결과: ",SettingTableCell.soundCheck)
        }
    }
    
    @IBAction func VibrationButton(_ sender: Any){
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
