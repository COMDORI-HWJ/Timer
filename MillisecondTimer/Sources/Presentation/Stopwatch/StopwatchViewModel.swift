//
//  StopwatchViewModel.swift
//  MillisecondTimer
//
//  Created by Wonji Ha on 2024/05/07.
//



import Foundation

final class StopwatchViewModel {
    private(set) var hour = 0, minute = 0, second = 0, milliSecond = 0
    
    @discardableResult
    func timeCalculate(_ remainTime: Double) -> (Int, Int, Int, Int) {
        hour = (Int)(fmod((remainTime/60/60), 100))
        minute = (Int)(fmod((remainTime/60), 60))
        second = (Int)(fmod(remainTime, 60))
        milliSecond = (Int)((remainTime - floor(remainTime))*1000)
        return (hour, minute, second, milliSecond)
    }
}
