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
        self.selectedIndex = 0 //첫 시작 화면을 탭바 0번으로 시작
        //                tabBarController?.selectedIndex = 3


        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(showPage(_:)), name: NSNotification.Name("showPage"), object: nil) //푸시 알림 옵저버
    }

    
    @objc func showPage(_ notification:Notification) {
        if let userInfo = notification.userInfo {
            if let index = userInfo["index"] as? Int {
                self.selectedIndex = index
            }
        }
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
