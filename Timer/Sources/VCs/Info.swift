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

    @IBOutlet weak var Profile: UIImageView!
    @IBOutlet weak var Info: UITextView!
    
    let info = "안녕하세요!\n앱 개발자 하원지입니다.\n밀리초타이머앱을 사용해주셔서 감사합니다.\n이 앱을 만들면서 많은 어려움을 겪었지만 출시하게 되어 정말 기쁘고 행복합니다. \n밀리초타이머 앱을 사용하면서 불편하거나 버그는 제보해주시면 감사합니다.\n또한 톡톡튀는 아이디어가 있으시다면 주저하지 마시고 문의 주시면 대단히 감사하겠습니다.\n추후 검토후 최대한 반영하여 업데이트 하겠습니다. \n\n마지막으로 앱 리뷰를 부탁드리겠습니다.\n짧아도 좋습니다! \n리뷰를 적어주시면 대단히 감사하겠습니다. \n좋은 하루 보내세요!"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        Info.text = info
        //Info.font = .systemFont(ofSize: 13.0)
        Info.isEditable = false
        // Do any additional setup after loading the view.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
 
}
