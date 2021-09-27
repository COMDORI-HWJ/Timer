////
////  Backup.swift
////  Timer
////
////  Created by WONJI HA on 2021/09/06.
////
//
//
//import UIKit
//
//class Backup: UIViewController {
//
//    //https://bite-sized-learning.tistory.com/175
//
//    //let timeSel : Selector = #selector(ViewController.start2)
//    var timer = Timer()
//    var playing : Bool = false
// //   let interval = 1.0
////    var  count =
//
//    var min:Int = 0
//    var sec1:Int  = 0
//
//
//
//    @IBOutlet weak var hourLabel: UILabel!
//    @IBOutlet weak var minLabel: UILabel!
//    @IBOutlet weak var secLabel: UILabel!
//
//    @IBOutlet weak var StartStopButton: UIButton!
//    @IBOutlet weak var ResetButton: UIButton!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//        self.navigationController?.navigationBar.topItem?.title="AD" //뷰 제목
//
//
//    }
//
//
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
//            StartStopButton.isEnabled = true
//
//        }
//    }
//
//
//
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
////    @IBAction func tapLongPress(_ sender: UILongPressGestureRecognizer){
////        if(sender.state == UIGestureRecognizer.State.began){
////            sec1 += 1
////            TimerLabel.text=String(sec1)
////        }
////        else if (sender.state == UIGestureRecognizer.State.ended){
////            print("길게 터치 중지")
////        }
////    }
////
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
//
//
//
//
//
//}
