//
//  MillisecondTimerViewModel.swift
//  MillisecondTimer
//
//  Created by Wonji Ha on 2024/05/20.
//

import Foundation
import UserNotifications

final class MillisecondTimerViewModel {
    private(set) var hourText = "", minuteText = "", secondText = "", millisecondText = ""
    private let notificationContent = UNMutableNotificationContent()
    private let notificationCenter = UNUserNotificationCenter.current()
    
    private(set) var mTimer = Mtimer()
//    var mTimer = Mtimer()
    
    func timeCalculate(_ time: Double) {
        mTimer.status = true
        mTimer.remainTime = mTimer.count - time
        mTimer.elapsed = mTimer.count - mTimer.remainTime
        currentTimerText(mTimer.remainTime)
        guard mTimer.remainTime > trunc(0) else {
            resetTime()
            return
        }
    }
    
    func timePauseCalculate() {
        mTimer.status = false
        mTimer.count = mTimer.count - mTimer.elapsed
    }
    
    func resetTime() {
        mTimer.count = 0
        mTimer.remainTime = 0
        mTimer.elapsed = 0
        mTimer.status = false
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
    
    // MARK: - Notification
    func sendTimerNotification() {
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: mTimer.count, repeats: false)
        let identifier = "Timer done"
        let request = UNNotificationRequest(identifier: identifier, content: notificationContent, trigger: trigger)
        notificationContent.subtitle = NotificationContentDescription.timerTitle.description
        notificationContent.body = NotificationContentDescription.timerBody.description
        notificationContent.badge = 1
        notificationContent.sound = .default
        notificationContent.userInfo = ["Timer": "done"]
        notificationCenter.add(request) { error in
            guard let error = error else {
                print("타이머푸시 알림 오류: ", error?.localizedDescription ?? "에러 없음")
                return
            }
            print("타이머 푸시 알림 성공")
        }
    }
    
    private func removeAllNotifications() {
        notificationCenter.removeAllDeliveredNotifications()
        notificationCenter.removeAllPendingNotificationRequests()
    }
    
    // MARK: - background Timer
    @objc
    func backgroundTimer() {
        print("백그라운드 타이머 진입")
        if mTimer.status == true {
            mTimer.backgroudTime = Date()
            print("백그라운드 타이머 남은 시간: ", mTimer.remainTime)
            print("타이머 상태: ", mTimer.status)
        }
        else if mTimer.status == false {
            removeAllNotifications()
            print("타이머 상태: ", mTimer.status)
        }
    }
    
    func backgroundTimeInterval(_ time: Double) {
        mTimer.count = mTimer.remainTime - time
        print("백그라운드 타이머 남은 시간: ", mTimer.remainTime)
        if mTimer.count < 0 {
            resetTime()
        }
    }
    
    // MARK: - Timer Count Controllers function
    func secondCountUp() {
        if(mTimer.count < 356400) {
            mTimer.count += 1
            print("타이머 현재 카운트: ", mTimer.count)
            currentTimerText(mTimer.count)
        }
    }
}
