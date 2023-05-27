//
//  TutorialContents.swift
//  Timer
//
//  Created by Wonji Ha on 2023/05/06.
//
/** Reference
 * https://kkh0977.tistory.com/2753 CGRect 사용해 x , y , width , height 좌표, 크기 설정 및 동적으로 UILabel 라벨 생성 실시
 * https://woongsios.tistory.com/57 status bar 높이 구하기 in Swift 5
 
 */
import UIKit
import Gifu


class TutorialContents: UIViewController {
    
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
        
        // 디바이스 상태 바 높이 사이즈 확인
        let statusBarFrameHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        
        titleLabel.frame = CGRect(x: 0, y: deviceHeight/20, width: deviceWidth, height: 30)
        print("현재 페이지: " , titleText!)
        contentLabel.frame = CGRect(x: 0, y: deviceHeight/9, width: deviceWidth, height: 50)
        
        
        gifImageView.frame = CGRect(x: 10, y: boundsHeight*0.2, width: deviceWidth-20, height: boundsHeight/2)
        gifImageView.translatesAutoresizingMaskIntoConstraints = true // 오토레이아웃 사용시 AutoresizingMask를 사용한 Constraints 변환을 막는 것
//        gifImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100).isActive = true
//        gifImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 100).isActive = true
//        gifImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -80).isActive = true
        view.addSubview(gifImageView)
        view.addSubview(titleLabel)
        view.addSubview(contentLabel)
//        titleLabel.frame = CGRectInset(CGRect, CGFloat, CGFloat)
    }
}
