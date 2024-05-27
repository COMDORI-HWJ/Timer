//
//  StopwatchViewModel.swift
//  MillisecondTimer
//
//  Created by Wonji Ha on 2024/05/07.
//

import UIKit

final class StopwatchViewModel {
    private var stopWatch: Timer?
    private var startTime = Date()
    private(set) var timeText = "", milliSecondText = ""
    private(set) var recordList: [String] = []
    private(set) var mTimer = Mtimer()
    
    func stopWatchPlay(timeUpdate: @escaping () -> Void) {
        let startTime = Date()
        stopWatch = Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true, block: { [weak self] _ in
            let timeInterval = Date().timeIntervalSince(startTime)
            self?.timeCalculate(timeInterval)
            timeUpdate()
            DispatchQueue.main.async { [weak self] in
                guard let stopWatch = self?.stopWatch else { return print("stopWatch not working") }
                RunLoop.current.add(stopWatch, forMode: .common)
            }
        })
        print("스톱워치 작동")
    }
    
    func stopWatchPause() {
        timePauseCalculate()
        stopWatch?.invalidate()
        print("스톱워치 일시중지")
    }
    
    private func timeCalculate(_ time: Double) {
        mTimer.status = true
        mTimer.remainTime = mTimer.count + time
        mTimer.elapsed = mTimer.count + mTimer.remainTime
        currentStopWatchText(mTimer.remainTime)
    }
    
    private func timePauseCalculate() {
        mTimer.status = false
        mTimer.count = mTimer.elapsed - mTimer.count
    }
    
    @discardableResult
    private func currentStopWatchText(_ remainTime: Double) -> (timeText: String, milliSecond: String) {
        var hour = 0, minute = 0, second = 0, milliSec = 0
        hour = (Int)(fmod((remainTime/60/60), 100))
        minute = (Int)(fmod((remainTime/60), 60))
        second = (Int)(fmod(remainTime, 60))
        milliSec = (Int)((remainTime - floor(remainTime))*1000)
        
        timeText = String(format: "%02d:%02d:%02d.", hour, minute, second)
        milliSecondText = String(format: "%03d", milliSec)
        return (timeText, milliSecondText)
    }
    
    func addRecord() {
        let record = "\(timeText)\(milliSecondText)" // 스톱워치 시간을 기록
        recordList.append(record)
        print("스톱워치 기록: ", recordList)
        print("스톱워치 기록 횟수 : ", recordList.count)
    }
    
    func resetRecords() {
        stopWatch?.invalidate()
        mTimer.count = 0
        mTimer.remainTime = 0
        mTimer.elapsed = 0
        recordList.removeAll()
        mTimer.status = false
    }
    
    func buttonVibrationEffect() {
        if(SettingTableCell.vibrationCheck == true) {
            print("진동: ",SettingTableCell.vibrationCheck)
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        }
        else {
            print("진동: ",SettingTableCell.vibrationCheck)
        }
    }
}
