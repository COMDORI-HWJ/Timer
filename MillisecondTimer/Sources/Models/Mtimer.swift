//
//  Mtimer.swift
//  MillisecondTimer
//
//  Created by Wonji Ha on 2024/05/07.
//

import Foundation

struct Mtimer {
    var hour : Int = 0, minute : Int = 0, second : Int = 0, milliSecond : Int = 0
    var status : Bool = false // 타이머 상태
    var count : Double = 0 // 타이머 시간
    var remainTime : Double = 0 // 남은 시간
    var elapsed : Double = 0// 경과시간
    var backgroudTime : Date? // 백그라운드 경과시간
}

enum TimeUnit: String {
    case hour
    case minute
    case second
    case millisecond
    
    var description: String {
        switch self {
        case .hour:
            return "시간"
        case .minute:
            return "분"
        case .second:
            return "초"
        case .millisecond:
            return "밀리초"
        }
    }
    
    func toSeconds(_ value: Double) -> Double {
        switch self {
        case .hour:
            return value * 3600
        case .minute:
            return value * 60
        case .second:
            return value
        case .millisecond:
            return value * 0.001
        }
    }
}
