//
//  AppDelegate.swift
//  Timer
//
//  Created by WONJI HA on 2021/07/06.
//

import UIKit
import GoogleMobileAds
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?


    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("이제 앱 실행 준비할게요")
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print("앱 실행 준비 끝")
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        UNUserNotificationCenter.current().delegate = self // 특정 ViewController에 구현되어 있으면 푸시를 받지 못할 가능성이 있으므로 AppDelegate에서 구현
        
        
        return true
    }
    
    /*
          앱이 종료되기 직전에 호출된다.
       하지만 메모리 확보를 위해 suspended 상태에 있는 앱이 종료될 때나
       background 상태에서 사용자에 의해 종료될 때나
       오류로 인해 앱이 종료될 때는 호출되지 않는다.
         */
    
      func applicationWillTerminate(_ application: UIApplication) {
              print("이제 곧 종료될거에요")
          }

    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
           
           return UIInterfaceOrientationMask.portrait //세로 화면 고정
       }
}
    
    extension AppDelegate : UNUserNotificationCenterDelegate {

        
        //ForeGround에서 작동 시키는 방법
       func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
                
                completionHandler([.list, .badge, .sound, .banner])
                
            }
        
        //눌렀을 때, 특정한 활동을 수행 할 수 있도록 하기
        func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
                
           //let noti = response.notification
            if response.actionIdentifier == UNNotificationDismissActionIdentifier {
                print("메시지 닫힘")
            }
            else if response.actionIdentifier == UNNotificationDefaultActionIdentifier {
                print("푸시메시지 클릭 함")
                
            }
            
            guard let rootViewController1 = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController else {
                           return
                    }
            print("scene얻음")
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)

            var conversationVC: UIViewController?
                conversationVC = storyboard.instantiateViewController(withIdentifier: "MTimer")
//                let tabBarVC = rootViewController1 as? UITabBarController,
//                let navVC = tabBarVC.selectedViewController as? UINavigationController
        
                
                // we can modify variable of the view controller using notification data
                // (eg: title of notification)
                // response.notification.request.content.userInfo
                //conversationVC.DisplayName = response.notification.request.content.
                    //navVC.pushViewController(conversationVC, animated: true)
                
                self.window?.rootViewController = conversationVC
                self.window?.makeKeyAndVisible()
          
            
            //            if let conversationVC = storyboard.instantiateViewController(withIdentifier: "MTimer") as? MainTimer,
//                              let navController = rootViewController1 as? UINavigationController{
//
//                           navController.pushViewController(conversationVC, animated: true)
//
//                   // set the view controller as root
//                window?.rootViewController = conversationVC
//
//                   //window?.makeKeyAndVisible()
//                              }
            completionHandler()
            }





    }


