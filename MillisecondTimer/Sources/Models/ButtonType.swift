//
//  ButtonType.swift
//  MillisecondTimer
//
//  Created by Wonji Ha on 2024/05/23.
//

import Foundation

enum ButtonType {
    case start
    case pause
    case reset
    case rap
    
    var name: String {
        switch self {
        case .start:
            return String(format: NSLocalizedString("시작", comment: "Start"))
        case .pause:
            return String(format: NSLocalizedString("일시중지", comment: "Pause"))
        case .reset:
            return String(format: NSLocalizedString("초기화", comment: "Reset"))
        case .rap:
            return String(format: NSLocalizedString("기록", comment: "Rap"))
        }
    }
}
