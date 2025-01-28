//
//  MillisecondTimerViewModel.swift
//  MillisecondTimer
//
//  Created by Wonji Ha on 2024/05/20.
//

import UIKit
import AVFoundation
import UserNotifications


final class MillisecondTimerViewModel {
    private var timer: Timer?
    private(set) var hourText = "", minuteText = "", secondText = "", millisecondText = ""
    private let notificationContent = UNMutableNotificationContent()
    private let notificationCenter = UNUserNotificationCenter.current()
    var timerTextCallback: (() -> Void)?
    weak var timerDelegate: MillisecondTimerDelegate?
    
    private(set) var mTimer = Mtimer()
    private let setting = SettingTableViewController()
    
    let maxCount: Double = 356400
    let minimumCount: Double = 0
    
    func timerPlay(timeUpdate: @escaping () -> (), timerReset: @escaping() -> ()) {
        mTimer.status = true
        let startTime = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true, block: { [self] _ in
            let timeInterval = Date().timeIntervalSince(startTime)
            timeCalculate(timeInterval)
            timeUpdate()
            guard mTimer.remainTime > trunc(0) else {
                if SettingTableViewController.soundCheck == true {
                    AudioServicesPlaySystemSound(1016)
                    AudioServicesPlaySystemSound(4095)
                }
                else {
                    print("Sound: ",SettingTableViewController.soundCheck)
                }
                resetTimer()
                timerReset()
                print("타이머 완료")
                return
            }
        })
    }
    
    func timerPause() {
        timerStop()
        mTimer.count = mTimer.count - mTimer.elapsed
        print("타이머 일시정지")
    }
    
    func timerStop() {
        mTimer.status = false
        timer?.invalidate()
    }
    
    func timeCalculate(_ time: Double) {
        mTimer.remainTime = mTimer.count - time
        mTimer.elapsed = mTimer.count - mTimer.remainTime
        currentTimerText(mTimer.remainTime)
    }
    
    func resetTimer() {
        timerStop()
        mTimer.count = 0
        mTimer.remainTime = 0
        mTimer.elapsed = 0
        timerDelegate?.timerDidReset()
        print("타이머 초기화")
    }
    
    func addSecondsToTimer(_ seconds: Double) {
        mTimer.count += seconds
        currentTimerText(mTimer.count) // 저장되어 있는 타이머 계속하여 누적 표시
    }
    
    @discardableResult
    func currentTimerText(_ count: Double) -> (hourText: String, minuteText: String, secondText: String, millisecondText: String) {
        var hour = 0, minute = 0, second = 0, millisecond = 0
        hour = (Int)(fmod((count/60/60), 100))
        minute = (Int)(fmod((count/60), 60))
        second = (Int)(fmod(count, 60))
        millisecond = (Int)((count - floor(count))*1001)
        
        hourText = String(format: "%02d", hour)
        minuteText = String(format: "%02d", minute)
        secondText = String(format: "%02d", second)
        millisecondText = String(format: "%03d", millisecond)
        return (hourText, millisecondText, secondText, millisecondText)
    }
    
    // MARK: - Foreground Timer
    @objc
    func foregroundTimer() {
        print("포그라운드 타이머 진입")
        print("타이머 상태: ", mTimer.status)
        guard let startTime = mTimer.backgroudTime else { return }
        let timeInterval = Date().timeIntervalSince(startTime)
        DispatchQueue.main.async { [weak self] in
            if self?.mTimer.status == true {
                self?.backgroundTimeInterval(timeInterval)
                self?.timerPlay {
                    self?.timerTextCallback?()
                } timerReset: { }
            }
            else {
                self?.timerStop()
            }
        }
    }
    
    // MARK: - Background Timer
    @objc
    func backgroundTimer() {
        print("백그라운드 타이머 진입")
        if mTimer.status == true {
            timerStop()
            mTimer.status = true
            mTimer.backgroudTime = Date()
            createTimerNotification()
            print("백그라운드 타이머 남은 시간: ", mTimer.remainTime)
            print("타이머 상태: ", mTimer.status)
        }
        else if mTimer.status == false {
            timerStop()
            removeAllNotifications()
            print("타이머 상태: ", mTimer.status)
        }
    }
    
    func backgroundTimeInterval(_ time: Double) {
        mTimer.count = mTimer.remainTime - time
        print("백그라운드 타이머 남은 시간: ", mTimer.remainTime)
        if mTimer.count < 0 {
            resetTimer()
        }
    }
    
    // MARK: - Timer Count Controllers function
    func addTimerCount(unit: TimeUnit) {
        let count: Double
        
        switch unit {
        case .hour:
            count = 3600
        case .minute:
            count = 60
        case .second:
            count = 1
        case .millisecond:
            count = 0.001
        default:
            print("오류 타이머 시간 증가 불가")
            break
        }
        if (mTimer.count < maxCount) {
            mTimer.count += count
            print("타이머 현재 카운트: ", mTimer.count)
            currentTimerText(mTimer.count)
        } else {
            print("타이머 시간 업데이트 불가")
        }
    }
    
    func subtractTimerCount(unit: TimeUnit) {
        let count: Double
        switch unit {
        case .hour:
            count = 3600
        case .minute:
            count = 60
        case .second:
            count = 1
        case .millisecond:
            count = 0.001
        default:
            print("오류 타이머 시간 감소 불가")
            break
        }
        if mTimer.count >= count {
            mTimer.count -= count
            print("타이머 현재 카운트: ", mTimer.count)
            currentTimerText(mTimer.count)
        } else {
            print("타이머 시간 업데이트 불가")
            print("타이머 현재 카운트: ", mTimer.count)
        }
    }
    
}

// MARK: - Timer Notification
extension MillisecondTimerViewModel: MillisecondTimerProtocol {
    func addTimerPushNotification() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(foregroundTimer), name: UIApplication.willEnterForegroundNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(backgroundTimer), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    func createTimerNotification() {
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: mTimer.count, repeats: false)
        let identifier = "Timer done"
        let request = UNNotificationRequest(identifier: identifier, content: notificationContent, trigger: trigger)
        notificationContent.subtitle = NotificationContentDescription.timerTitle.description
        notificationContent.body = NotificationContentDescription.timerBody.description
        notificationContent.badge = 1
        notificationContent.sound = .default
        notificationContent.userInfo = ["Timer": "done"]
        notificationCenter.add(request) { error in
            if let error = error {
                print("타이머푸시 알림 오류: ", error.localizedDescription)
                return
            }
            else {
                print("타이머 푸시 알림 성공")                
            }
        }
    }
    
    private func removeAllNotifications() {
        notificationCenter.removeAllDeliveredNotifications()
        notificationCenter.removeAllPendingNotificationRequests()
    }
}
