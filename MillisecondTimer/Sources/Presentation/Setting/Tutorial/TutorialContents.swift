//
//  TutorialContents.swift
//  Timer
//
//  Created by Wonji Ha on 2023/05/06.
//

import UIKit
import Gifu

final class TutorialContents: UIViewController {
    
    var titleText: String!
    var contentText: String!
    var imageFile: String!
    var pageIndex: Int!
    
    var titleLabel: UILabel!
    var contentLabel: UILabel!
    let gifImageView = GIFImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gifImageView.animate(withGIFNamed: imageFile)
        
        titleLabel = UILabel()
        titleLabel.text = titleText
        titleLabel.sizeToFit() // 레이블 객체 텍스트 동적 설정 레이블 너비를 텍스트 길에 맞추는 역할
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
        
        contentLabel = UILabel()
        contentLabel.text = contentText
        contentLabel.sizeToFit()
        contentLabel.numberOfLines = 0 // 자동 줄바꿈
        contentLabel.textAlignment = .center
        contentLabel.font = UIFont.systemFont(ofSize: UIFont.labelFontSize)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // 디바이스 화면 사이즈 확인
        let bounds = UIScreen.main.bounds
        let boundsHeight = bounds.size.height
        let deviceWidth = self.view.frame.size.width
        let deviceHeight = self.view.frame.size.height
        
        titleLabel.frame = CGRect(x: 0, y: deviceHeight/20, width: deviceWidth, height: 30)
        print("현재 페이지: " , titleText!)
        contentLabel.frame = CGRect(x: 0, y: deviceHeight/9, width: deviceWidth+3, height: 50)
        
        gifImageView.frame = CGRect(x: 10, y: boundsHeight*0.2, width: deviceWidth-20, height: boundsHeight/2)
        gifImageView.translatesAutoresizingMaskIntoConstraints = true // 오토레이아웃 사용시 AutoresizingMask를 사용한 Constraints 변환을 막는 것
        view.addSubview(gifImageView)
        view.addSubview(titleLabel)
        view.addSubview(contentLabel)
    }
}
