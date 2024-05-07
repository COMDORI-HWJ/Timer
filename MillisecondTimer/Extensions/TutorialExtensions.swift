//
//  TutorialExtensions.swift
//  Timer
//
//  Created by Wonji Ha on 2023/07/18.
//

import UIKit
import Foundation

extension UIViewController {
    var mainSb: UIStoryboard {
           return UIStoryboard(name: "Main", bundle: Bundle.main)
       }
       func instanceTutorial(name: String) -> UIViewController? {
           return self.mainSb.instantiateViewController(withIdentifier: name)
       }
   }
