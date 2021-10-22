//
//  Info.swift
//  Timer
//
//  Created by WONJI HA on 2021/10/14.
//

import Foundation
import UIKit


class Stopwatch: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
      
        
    

    }
 
    
    @IBOutlet weak var Label: UILabel!
    @IBOutlet weak var b: UIButton!
    
    @IBAction func vButton(_ sender: Any)
    {
        testLabel()
    }
    
   func testLabel()
    {
        Label.text = "test"
    }
}
