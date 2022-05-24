//
//  AppDelegate.swift
//  Timer
//
//  Created by WONJI HA on 2021/07/06.
//

import UIKit
import GoogleMobileAds

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
        
//        NotificationCenter.userRequest()
        setUNUserNotificationDelegate()
        
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
        
        // 위임자 설정
        func setUNUserNotificationDelegate(){
//            NotificationCenter.delegate = self
        }
        
        //ForeGround에서 작동 시키는 방법
            func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
                
                let userInfo = notification.request.content.userInfo
                print("유저정보: ", userInfo)
                
                completionHandler([.list, .sound, .banner, .sound, .badge])
                let application = UIApplication.shared
                
                if application.applicationState == .active
                {
                    print("푸쉬알림 탭 앱 켜짐")
                }
                if application.applicationState == .inactive
                {
                    print("푸쉬알림 탭 앱 꺼짐")
                }
                
            }
        
        //눌렀을 때, 특정한 활동을 수행 할 수 있도록 하기
            func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
                
                guard let rootViewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController else {
                       return
                }
                
                let storyboard = UIStoryboard(name: "MTimer", bundle: nil)
                let mTimer = MainTimer()
                let storyboardID = mTimer.storyboardId
                
                if response.notification.request.identifier == "Local Notification" {
                    print("Hello Local Notification")
                    
                    if  let secondVC = storyboard.instantiateViewController(withIdentifier: storyboardID) as? MainTimer,
                           let navController = rootViewController as? UINavigationController{

                        navController.pushViewController(secondVC, animated: true)
                        
                    }
                    
                }
        
    }
    }

