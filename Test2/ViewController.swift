//
//  ViewController.swift
//  Timer
//
//  Created by WONJI HA on 2021/07/06.

/*
 Reference
 https://kwangsics.tistory.com/entry/Swift-%ED%95%A8%EC%88%98-%EC%A0%95%EC%9D%98%EC%99%80-%ED%98%B8%EC%B6%9C?category=606525 함수 정의 및 호출
 https://bite-sized-learning.tistory.com/175 타이머1
 https://youtu.be/3TbdoVhgQmE 타이머2
 */

import UIKit

class ViewController: UIViewController {
    
//    let timeSel : Selector = #selector(ViewController.start2)
    
    var timer = Timer()
    var timercount : Bool = false
    var count : Int = 0
    
    var min:Int = 0
    var sec1:Int  = 0

    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var secLabel: UILabel!
    
    @IBOutlet weak var TimerLabel: UILabel!
    @IBOutlet weak var StartStopButton: UIButton!
    @IBOutlet weak var ResetButton: UIButton!
    @IBOutlet weak var secUpButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.topItem?.title="AD" //뷰 제목
    

    }
    
 
//    @IBAction func start1(_ sender: Any) { /*분*/
//
//        if(min  > -1){
//            minLabel.text = String(min)
//            timer = Timer.scheduledTimer(timeInterval: 60.0,  target: self, selector: timeSel, userInfo: nil, repeats:false)
//            min = min-1
//            print(sec1)
//        StartStopButton.isEnabled = false
//        }
//        else{
//            timer.invalidate()
//            StartStopButton.isEnabled = true
//
//        }
//    }
//
//    @IBAction func start2(_ sender: Any) { /*초*/
//
//        if(sec1  > -1){
//            print(playing)
//            secLabel.text = String(sec1)
//            timer = Timer.scheduledTimer(timeInterval: 1.0,  target: self, selector: timeSel, userInfo: nil, repeats:false)
//            sec1 -= 1
//            print(sec1)
//        StartStopButton.isEnabled = false
//        }
//        else{
//            timer.invalidate()
////            StartStopButton.isEnabled = true
//
//        }
//    }
//
//    @objc
//
//    @IBAction func B1(_ sender: Any) {
//                print("버튼을 눌렀습니다.")
//    }
//
//    @IBAction func Reset1 (_ sender: Any) {
//        sec1 = 0
//        secLabel.text="\(sec1)"
//        timer.invalidate()
//        print("타이머를 리셋하였습니다")
//        StartStopButton.setTitle("Start", for: .normal)
//        StartStopButton.isEnabled = true
//    }
//
//    @IBAction func up2 (_ sender: Any) {
//        if(min<60){
//            min += 1
//            print(min,"분을 증가 하였습니다")
//            minLabel.text="\(min)"
//        }
//        else if(sec1<61){
//            print("시간이 증가하지 않습니다.")
//        }
//
//    }
//
//    @IBAction func up3 (_ sender: Any) {
//        if(sec1<60){
//            sec1 += 1
//            print(sec1,"값 입니다")
//            secLabel.text="\(sec1)"
//        }
//        else if(sec1<61){
//            print("시간이 증가하지 않습니다.")
//        }
//
//    }
//
//
//    @IBAction func B3 (_ sender: Any) {
//        let bt = UIButton()
//        if(sec1>1){
//            sec1 = sec1-1
//        }
//        else if(sec1>0){
//            sec1 -= 1
//        }
//        bt.setTitle("STOP", for: .normal)
//
//        print(sec1,"값 입니다")
//        secLabel.text="\(sec1)"
//
//    }
    
    @IBAction func start_stop(_ sender: Any)
    {
        if(timercount)
        {
            timercount = false
            timer.invalidate()
            StartStopButton.setTitle("Start", for: .normal)
            
        }
        else
        {
            timercount = true
            StartStopButton.setTitle("Pause", for: .normal)
            print("일시정지")
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
        }
        
    }
    
    func Reset() /* 초기화 함수 선언 */
    {
        self.count = 0
        self.timer.invalidate()
        self.TimerLabel.text = self.makeTimeString(hours: 0, minutes: 0, seconds: 0)
        self.StartStopButton.setTitle("Start", for: .normal)
        
    }
    
    @IBAction func ResetButton(_ sender: Any)
    {
       Reset() //초기화 함수 호출
        print("초기화 되었습니다.")
    }
    
    func timeLabel()
    {
        let time = secondsToHoursMinutesSeconds(seconds: count)
        let timeText = makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
        TimerLabel.text = timeText
        
    }
    
    @objc func timerCounter() -> Void
    {
        if(count > 0)
        {
            count = count - 1
            print(count , "시간입니다")
            timeLabel()
            if(count == 0)
            {
                Reset()
                print("0초가 되었습니다 및 초기화")
            }
        }
    }
    
    func secondsToHoursMinutesSeconds(seconds: Int) -> (Int, Int, Int)
    {
        return ((seconds / 3600), ((seconds % 3600) / 60),((seconds % 3600) % 60))
    }
    
    func makeTimeString(hours: Int, minutes: Int, seconds : Int) -> String
    {
        var timeString = ""
        timeString += String(format: "%02d", hours)
        timeString += ":"
        timeString += String(format: "%02d", minutes)
        timeString += ":"
        timeString += String(format: "%02d", seconds)
        return timeString
    }
    
    @IBAction func secUp(_ sender:Any)
    {
//        let time = secondsToHoursMinutesSeconds(seconds: count)
//        let timeString = makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
        
        count += 1
        print(count,"시간을 증가 하였습니다")
        timeLabel()
//        TimerLabel.text = timeString
    }
    


}
