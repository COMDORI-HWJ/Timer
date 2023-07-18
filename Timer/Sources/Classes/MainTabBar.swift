//
//  MainTabBar.swift
//  Timer
//
//  Created by Wonji Ha on 2022/06/10.
//

import UIKit

class MainTabBar: UITabBarController {
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.selectedIndex = 0 // 첫 시작 화면을 탭바 0번으로 시작
        NotificationCenter.default.addObserver(self, selector: #selector(showPage(_:)), name: NSNotification.Name("showPage"), object: nil) // 푸시 알림 옵저버
    }
    
    override func viewDidAppear(_ animated: Bool) { // https://scshim.tistory.com/284 whose view is not in the window hierarchy!
        print("튜토리얼 화면 작동")
        let ud = UserDefaults.standard
        if ud.bool(forKey: UserInfoKey.tutorial) == false {
            let vc = instanceTutorial(name: "TutorialVC")
            self.present(vc!, animated: true)
            return
        }
    }
    
    @objc func showPage(_ notification:Notification) {
        if let userInfo = notification.userInfo {
            if let index = userInfo["index"] as? Int {
                self.selectedIndex = index
            }
        }
    }
}
