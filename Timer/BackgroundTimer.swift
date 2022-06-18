//
//  BackgroundTimer.swift
//  Timer
//
//  Created by WONJI HA on 2021/11/11.
//

/*
 Reference

 */

import UIKit
import AVFoundation //햅틱



class BackgroundTimer: UIViewController {

    @IBOutlet weak var TimeLabel: UILabel!
    @IBOutlet weak var StartStopButton: UIButton!
    @IBOutlet weak var ResetButton: UIButton!


    @IBOutlet weak var hourUpButton: UIButton!
    @IBOutlet weak var hourDownButton: UIButton!

    @IBOutlet weak var minUpButton: UIButton!
    @IBOutlet weak var minDownButton: UIButton!

    @IBOutlet weak var secUpButton: UIButton!
    @IBOutlet weak var secDownButton: UIButton!

    @IBOutlet weak var millisecUpButton: UIButton!
    @IBOutlet weak var millisecDownButton: UIButton!

    var timerCounting:Bool = false
    var startTime:Date?
    var stopTime:Date?
    var count : Int = 0

    let userDefaults = UserDefaults.standard
    let START_TIME_KEY = "startTime"
    let STOP_TIME_KEY = "stopTime"
    let COUNTING_KEY = "countingKey"

    var timer : Timer!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setRadius() //버튼 둥글게 만들기

        startTime = userDefaults.object(forKey: START_TIME_KEY) as? Date
        stopTime = userDefaults.object(forKey: STOP_TIME_KEY) as? Date
        timerCounting = userDefaults.bool(forKey: COUNTING_KEY)


        if timerCounting
        {
            startTimer()
            print("시작")
        }
        else
        {
            stopTimer()
            if let start = startTime
            {
                if let stop = stopTime
                {
                    let time = calcRestartTime(start: start, stop: stop)
                    let diff = Date().timeIntervalSince(time)

                    setTimeLabel(Int(diff))
                    print(Int(diff),"시간")
                }
            }
        }
    }

    @IBAction func Start_Stop_Action(_ sender: Any)
    {
        if timerCounting
        {
            setStopTime(date: Date())
            stopTimer()
        }
        else
        {
            if let stop = stopTime
            {
                let restartTime = calcRestartTime(start: startTime!, stop: stop)
                setStopTime(date: nil)
                setStartTime(date: restartTime)
            }
            else
            {
                setStartTime(date: Date())
            }

            startTimer()
        }
    }

    func calcRestartTime(start: Date, stop: Date) -> Date
    {
        let diff = start.timeIntervalSince(stop)
        return Date().addingTimeInterval(diff+8)
        
    }
    func startTimer()
    {
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
        setTimerCounting(true)
        StartStopButton.setTitle("STOP", for: .normal)
        StartStopButton.setTitleColor(UIColor.red, for: .normal)
    }

    @objc func timerCounter()
    {
        if let start = startTime
        {
            count += 8
            let diff = Date().timeIntervalSince(start)
            setTimeLabel(Int(diff))
            print(Int(diff))
        }
        else
        {
            stopTimer()
            setTimeLabel(0)
        }
    }

    func setTimeLabel(_ val: Int)
    {
        let time = secondsToHoursMinutesSeconds(val)
        let timeString = makeTimeString(hour: time.0, min: time.1, sec: time.2, mill: time.3)
        TimeLabel.text = timeString
    }

    func secondsToHoursMinutesSeconds(_ ms: Int) -> (Int, Int, Int, Int)
    {
        //return ((ms / 3600000), ((ms % 3600000) / 60000), ((ms % 60000) / 1000), (ms % 3600000) % 1000) //1시간을 1밀리초로 환산하여 계산함. ex)3600000밀리초는 1시간
        let hour = ms / 3600000
        let min = (ms % 3600000) / 60000
        let sec = (ms % 60000) / 1000
        let mill = (ms % 3600000) % 1000
        return (hour, min, sec, mill)

    }

    func makeTimeString(hour: Int, min: Int, sec: Int, mill: Int) -> String
    {
        var timeString = ""
        timeString += String(format: "%02d", hour)
        timeString += ":"
        timeString += String(format: "%02d", min)
        timeString += ":"
        timeString += String(format: "%02d", sec)
        timeString += ":"
        timeString += String(format: "%03d", mill)

        return timeString
    }

    func stopTimer()
    {
        if timer != nil
        {
            timer.invalidate()
        }
        setTimerCounting(false)
        StartStopButton.setTitle("START", for: .normal)
        StartStopButton.setTitleColor(UIColor.systemGreen, for: .normal)
    }

    @IBAction func ResetAction(_ sender: Any)
    {
        setStopTime(date: nil)
        setStartTime(date: nil)
        TimeLabel.text = makeTimeString(hour: 0, min: 0, sec: 0, mill: 0)
        stopTimer()
        count = 0
    }

    func setStartTime(date: Date?)
    {
        startTime = date
        userDefaults.set(startTime, forKey: START_TIME_KEY)
    }

    func setStopTime(date: Date?)
    {
        stopTime = date
        userDefaults.set(stopTime, forKey: STOP_TIME_KEY)
    }

    func setTimerCounting(_ val: Bool)
    {
        timerCounting = val
        userDefaults.set(timerCounting, forKey: COUNTING_KEY)
    }
    
    func setRadius()
    {
        hourUpButton.layer.cornerRadius = 4
        hourDownButton.layer.cornerRadius = 4
        StartStopButton.layer.cornerRadius = 5
    }
}






