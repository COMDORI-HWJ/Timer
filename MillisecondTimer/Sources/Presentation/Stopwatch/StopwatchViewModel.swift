//
//  StopwatchViewModel.swift
//  MillisecondTimer
//
//  Created by Wonji Ha on 2024/05/07.
//



import Foundation

final class StopwatchViewModel {
    private let startTime = Date()
    private(set) var timeText = "", milliSecond = ""
    private(set) var mTimer = Mtimer()
    private(set) var recordList: [String] = [] // 스톱워치 시간 기록 배열
    
    
    func timeCalculate(_ time: Double) {
        mTimer.status = true
        mTimer.remainTime = mTimer.count + time
        mTimer.elapsed = mTimer.count + mTimer.remainTime
        currentStopWatchText(mTimer.remainTime)
    }
    
    func timePauseCalculate() {
        mTimer.status = false
        mTimer.count = mTimer.elapsed - mTimer.count
    }
    
    @discardableResult
    func currentStopWatchText(_ remainTime: Double) -> (timeText: String, milliSecond: String) {
        var hour = 0, minute = 0, second = 0, milliSec = 0
        hour = (Int)(fmod((remainTime/60/60), 100))
        minute = (Int)(fmod((remainTime/60), 60))
        second = (Int)(fmod(remainTime, 60))
        milliSec = (Int)((remainTime - floor(remainTime))*1000)
        
        timeText = String(format: "%02d:%02d:%02d.", hour, minute, second)
        milliSecond = String(format: "%03d", milliSec)
        return (timeText, milliSecond)
    }
    
    func addRecord() {
        let record = "\(timeText)\(milliSecond)" // 스톱워치 시간을 기록
        recordList.append(record)
        print("스톱워치 기록: ", recordList)
        print("스톱워치 기록 횟수 : ", recordList.count)
    }
    
    func resetRecords() {
        mTimer.count = 0
        mTimer.remainTime = 0
        mTimer.elapsed = 0
        recordList.removeAll()
        mTimer.status = false
    }
}
