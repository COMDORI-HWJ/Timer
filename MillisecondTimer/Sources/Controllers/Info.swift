//
//  Info.swift
//  Timer
//
//  Created by Wonji Ha on 2022/08/10.
//

/* Reference
https://scshim.tistory.com/77 UITextView
https://withthemilkyway.tistory.com/31 텍스트뷰 설명
 
 */
import UIKit

class Info: UIViewController {
    
    @IBOutlet weak var Info: UITextView!
    @IBOutlet weak var backBtn: UIBarButtonItem!
    @IBOutlet weak var ver: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Info.text = info
        Info.isEditable = false
        appver()
        
    }
    
    let info = String(format: NSLocalizedString("안녕하세요! 🙋🏻‍♂️\n앱 개발자 하원지입니다.\n밀리초타이머 앱을 사용해 주셔서 감사합니다.\n이 앱을 출시하게 되어 정말 기쁘고 행복합니다. 😄 \n밀리초타이머 앱을 사용하면서 불편한 점이나 버그는 제보해 주시면 수정하도록 하겠습니다.\n또한 새로운 기능 아이디어가 있으시다면 주저하지 마시고 의견을 주시면 추후 검토 후 최대한 반영하여 업데이트하겠습니다. \n\n마지막으로 앱 리뷰를 부탁드리겠습니다.\n짧아도 좋습니다! \n좋은 하루 보내세요! \n감사합니다.", comment: "안내문"))
    
    @IBAction func backBtn(_ sender: Any) {
        //        self.presentedViewController?.dismiss(animated: true, completion: nil)
        dismiss(animated: true, completion: nil)
        print("뒤로가기 버튼을 눌렀습니다.")
    }
    
    func appver () {
        print("앱버전", SettingTableViewController().version())
        ver.text =  String(format: NSLocalizedString("버전 : ", comment: "App Version"))+"\(SettingTableViewController().version())"
    }
}
