//
//  MillisecondTimerProtocols.swift
//  MillisecondTimer
//
//  Created by Wonji Ha on 2024/06/14.
//

import Foundation

protocol MillisecondTimerDelegate: AnyObject {
    func timerDidReset()
    func timeLabelText()
    
}

protocol MillisecondTimerProtocol: AnyObject {
    func addTimerPushNotification()
}
