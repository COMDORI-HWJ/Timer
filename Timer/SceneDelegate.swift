//
//  SceneDelegate.swift
//  Timer
//
//  Created by WONJI HA on 2021/07/06.
//

/*
Reference
https://fomaios.tistory.com/entry/%EC%95%B1-%EC%83%9D%EB%AA%85%EC%A3%BC%EA%B8%B0App-LifeCycle-1?category=851398 - 생명주기

 */
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var bgTask: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
    var backcount = 0
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        UIApplication.shared.isIdleTimerDisabled = true //화면 꺼짐 방지 슬립모드 방지
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
        print("씬연결 끊김.")
    }
    
    /*
      씬이 비활성상태에서 활성상태로 진입하고 난 직후 호출된다.
      앱이 실제로 사용되기 전에 마지막으로 준비할 수 있는 코드를 작성할 수 있다.
      활성화 상태
     */



    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        print("씬 활성화")
    }
    
    /*
      활성상태에서 비활성상태로 가기 직전에 호출된다.
      홈버튼을 누르거나 다른 어플리케이션으로 이동했을 때 주로 발생한다.
     활성화 상태에서 비활성화 상태를 거쳐 백그라운드 상태가 된다.
      */

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        print("씬 비활성화 상태")
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        print("포어그라운드 상태")
        
    
    }
    
    /*
    씬이 백그라운드나 낫러닝에서 포어그라운드로 들어가기 직전에 호출된다.
    비활성화 상태를 거쳐 활성화 상태가 된다.
   */
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        print("백그라운드 상태")
        
       
        
//        let _: Timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (timer:Timer) in
//            self.backcount += 1
//            print("Timer Count: ", self.backcount)
//
////            if count >= 10 {
////                timer.invalidate()
////                self.endBackground()
////            }
//        }



            
    }
    

    
    /*
     씬이 백그라운드 상태로 들어갔을 때 호출된다.
     suspended 상태가 되기 전 중요한 데이터를 저장하는 등 종료하기 전에 필요한 작업을 한다.
     특별한 처리가 없다면 곧바로 suspennded상태로 전환된다.
    */
    func endBackground() {
        UIApplication.shared.endBackgroundTask(bgTask)
       // bgTask = UIBackgroundTaskInvalid
        print("endBackgroud Callback Method Fired!")
    }

    
}

