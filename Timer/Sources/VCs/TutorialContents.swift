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
    var imageFile: String!
    var pageIndex: Int!
    
    var titleLabel: UILabel!
    let gifImageView = GIFImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        gifImageView.animate(withGIFNamed: imageFile)
        
        titleLabel = UILabel()
        titleLabel.text = titleText
        titleLabel.sizeToFit() // 레이블 객체 텍스트 동적 설정 레이블 너비를 텍스트 길에 맞추는 역할
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)
    }
        
    override func viewWillAppear(_ animated: Bool) {
        
        // 디바이스 화면 사이즈 확인
        let deviceWidth = self.view.frame.size.width
        
        // 디바이스 상태 바 높이 사이즈 확인
        let statusBarFrameHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        
        titleLabel.frame = CGRect(x: 0, y: statusBarFrameHeight/3, width: deviceWidth, height: 30)
        print("현재 페이지: " , titleText!)
        
        gifImageView.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width, height: view.safeAreaLayoutGuide.layoutFrame.height)
        view.addSubview(gifImageView)
        view.addSubview(titleLabel)
//        titleLabel.frame = CGRectInset(CGRect, CGFloat, CGFloat)
    }
}
