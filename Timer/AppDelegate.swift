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
