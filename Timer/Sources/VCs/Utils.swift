//
//  Utils.swift
//  Timer
//
//  Created by Wonji Ha on 2023/05/06.
//

import UIKit

extension UIViewController {
    var tutorialSB: UIStoryboard {
           return UIStoryboard(name: "Main", bundle: Bundle.main)
       }
       func instanceTutorialVC(name: String) -> UIViewController? {
           return self.tutorialSB.instantiateViewController(withIdentifier: name)
       }
   }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


