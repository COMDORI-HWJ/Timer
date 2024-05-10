//
//  StopwatchViewModel.swift
//  MillisecondTimer
//
//  Created by Wonji Ha on 2024/05/07.
//



import Foundation

final class StopwatchViewModel {
    private(set) var hour = "", minute = "", second = "", milliSecond = ""
    
    @discardableResult
    func timeCalculate(_ remainTime: Double) -> (String, String, String, String) {
        var hou = 0, min = 0, sec = 0, milliSec = 0
        hou = (Int)(fmod((remainTime/60/60), 100))
        min = (Int)(fmod((remainTime/60), 60))
        sec = (Int)(fmod(remainTime, 60))
        milliSec = (Int)((remainTime - floor(remainTime))*1000)
        
        hour = String(format: "%02d:", hou)
        minute = String(format: "%02d:", min)
        second = String(format: "%02d.", sec)
        milliSecond = String(format: "%03d", milliSec)
        return (hour, minute, second, milliSecond)
    }
}
