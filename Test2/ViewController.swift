//
//  ViewController.swift
//  Test2
//
//  Created by WONJI HA on 2021/07/06.
//

import UIKit

class ViewController: UIViewController {
    
    //https://bite-sized-learning.tistory.com/175
    
    let timeSel : Selector = #selector(ViewController.start)
    var timer = Timer()
    var playing : Bool = false
 //   let interval = 1.0
//    var  count =
    
    var  t1  = 0;
    
    @IBOutlet weak var TimerLabel: UILabel!
    @IBOutlet weak var StartStopButton: UIButton!
    @IBOutlet weak var ResetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.topItem?.title="AD" //뷰 제목
    

    }
    
 
    @IBAction func start(_ sender: Any) {
 
    
        if(t1 > -1){
            print(playing)
            TimerLabel.text = String(t1)
            timer = Timer.scheduledTimer(timeInterval: 1,  target: self, selector: timeSel, userInfo: nil, repeats:false)
            t1 -= 1
            print(t1)
        StartStopButton.isEnabled = false
        }
        else{
            timer.invalidate()
            StartStopButton.isEnabled = true

         
        }
        
    
           
            
      
        }

        

    
       
    
    
    @objc
    
    @IBAction func B1(_ sender: Any) {
                print("버튼을 눌렀습니다.")
    }
    
    @IBAction func Reset1 (_ sender: Any) {
        t1 = 0
        TimerLabel.text="\(t1)"
        timer.invalidate()
        print("타이머를 리셋하였습니다")
        StartStopButton.setTitle("Start", for: .normal)
        StartStopButton.isEnabled = true
    }

    @IBAction func B2 (_ sender: Any) {
        if(t1<60){
            t1 += 1
            print(t1,"값 입니다")
            TimerLabel.text="\(t1)"
        }
        else if(t1<61){
            print("시간이 증가하지 않습니다.")
        }

    }
    
    @IBAction func tapLongPress(_ sender: UILongPressGestureRecognizer){
        if(sender.state == UIGestureRecognizer.State.began){
            t1 += 1
            TimerLabel.text=String(t1)
        }
        else if (sender.state == UIGestureRecognizer.State.ended){
            print("길게 터치 중지")
        }
    }
    
    @IBAction func B3 (_ sender: Any) {
        let bt = UIButton()
        if(t1>1){
            t1 = t1-1
        }
        else if(t1>0){
            t1 -= 1
        }
        bt.setTitle("STOP", for: .normal)
        
        print(t1,"값 입니다")
        TimerLabel.text="\(t1)"
        
    }
    
    
    func onTapButton() {
        
        
    }


}

