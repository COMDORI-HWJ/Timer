//
//  NotificationContentDescription.swift
//  MillisecondTimer
//
//  Created by Wonji Ha on 2024/05/26.
//

import Foundation

enum NotificationContentDescription {
    case timerTitle
    case timerBody
    
    var description: String {
        switch self {
        case .timerTitle:
            String(format: NSLocalizedString("타이머 완료", comment: "Timer done"))
        case .timerBody:
            String(format: NSLocalizedString("0초가 되었습니다. 타이머를 다시 작동하려면 알림을 탭하세요!", comment: ""))
        }
    }
}
