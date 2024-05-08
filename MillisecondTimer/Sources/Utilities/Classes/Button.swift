//
//  Button.swift
//  Timer
//
//  Created by Wonji Ha on 2022/04/08.
//
/*
 Reference
 https://fdee.tistory.com/entry/Xcode-%EA%B8%B0%EB%8A%A5-%EB%B2%84%ED%8A%BC-%EB%B7%B0-%EB%AA%A8%EC%84%9C%EB%A6%AC-%EB%91%A5%EA%B8%80%EA%B2%8C-%EB%A7%8C%EB%93%A4%EA%B8%B0-button-view-cornerRadius 버튼 둥글게
 */

import UIKit

@IBDesignable
class Button: UIButton {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    @IBInspectable var cornerRadius: CGFloat = 0{
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0{
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear{
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
}
