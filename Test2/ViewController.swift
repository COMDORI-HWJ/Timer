//
//  ViewController.swift
//  Test2
//
//  Created by WONJI HA on 2021/07/06.
//

import UIKit

class ViewController: UIViewController {
    
    var t1  = 0;

    
    @IBOutlet weak var TimerLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @objc
    @IBAction func B1(_ sender: Any) {
                print("버튼을 눌렀습니다.")
    }

    @IBAction func B2 (_ sender: Any) {
        t1 += 1
        print(t1,"값 입니다")
        TimerLabel.text="\(t1)"
        
    }
    
    @IBAction func tapLongPress(_ sender: UILongPressGestureRecognizer){
        if(sender.state == UIGestureRecognizer.State.began){
            t1 += 1
            TimerLabel.text="\(t1)"
        }
        else if (sender.state == UIGestureRecognizer.State.ended){
            print("길게 터치 중지")
        }
    }
    
    @IBAction func B3 (_ sender: Any) {
        if(t1>1){
            t1 = t1-1
        }
        else if(t1>0){
            t1 -= 1
        }
        
        print(t1,"값 입니다")
        TimerLabel.text="\(t1)"

        
    }
    
    
    func onTapButton() {
        
        
    }


}

