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
