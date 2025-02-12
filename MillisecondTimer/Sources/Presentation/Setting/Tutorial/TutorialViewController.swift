//
//  TutorialViewController.swift
//  Timer
//
//  Created by Wonji Ha on 2023/05/06.
//

import UIKit

final class TutorialViewController: UIViewController, UIPageViewControllerDataSource {
    
    @IBOutlet weak var exitButton: UIButton!
    
    var pageVC : UIPageViewController!
    var pageControl : UIPageControl!
    var tutorialTitles = [String(format: NSLocalizedString("환영합니다!", comment: "환영합니다")),
                          String(format: NSLocalizedString("시간 추가 방법", comment: "시간추가방법")),
                          String(format: NSLocalizedString("시간 빼는 방법", comment: "시간뺴는방법")),
                          String(format: NSLocalizedString("입력해서 타이머 맞추기", comment: "타이머입력"))]
    var tutoriaContents = [String(format: NSLocalizedString("밀리초타이머앱을 다운받아 주셔서 감사합니다.\n페이지를 넘겨서 사용 방법을 알아보세요!", comment: "설명1")),
                           String(format: NSLocalizedString("+ 버튼을 눌러서 시간을 추가해 보세요.", comment: "설명2")),
                           String(format: NSLocalizedString("- 버튼을 눌러서 시간을 줄여보세요.", comment: "설명3")),
                           String(format: NSLocalizedString("숫자를 눌러서 타이머 시간을 맞춰보세요.", comment: "설명4"))]
    var tutorialImages = ["tutorial1", "tutorial2", "tutorial3", "tutorial4"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// page view controller 속성 정의
        pageVC = instanceTutorial(name: "PageViewController") as? UIPageViewController
        pageVC.dataSource = self
        
        /// page view controller에서 페이지가 될 부분 삽입
        let startTutorial = self.getContentVC(atIndex: 0)! // as! TutorialContents
        
        /// 스와이프 할 때마다 이 배열에 하나씩 추가 됨
        pageVC.setViewControllers([startTutorial], direction: .forward, animated: true)
        pageVC.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 90)
        
        // pageView 컨트롤러를 마스터 뷰 컨트롤러의 자식으로 설정
        self.addChild(pageVC)
        self.view.addSubview(pageVC.view)
        pageVC.didMove(toParent: self) // 자식 뷰 컨트롤러에게 부모 뷰 컨트롤러가 바뀌었음을 알림
        
        // page indicator 외형 템플릿
        pageControl = UIPageControl.appearance()
        pageControl.pageIndicatorTintColor = UIColor.systemGray
        pageControl.currentPageIndicatorTintColor = UIColor.systemBlue
        pageControl.backgroundColor = .systemBackground
    }
    
    // 표현하려는 컨텐츠 뷰에 내용을 세팅한 후, DataSource이벤트에서 사용될 뷰컨트롤러 반환
    func getContentVC(atIndex idx: Int) -> UIViewController? {
        
        // index 범위 체크
        guard tutorialTitles.count > idx && tutorialTitles.count > 0 else { return nil }
        let tc = TutorialContents()
        tc.titleText = tutorialTitles[idx]
        tc.contentText = tutoriaContents[idx]
        tc.imageFile = tutorialImages[idx]
        tc.pageIndex = idx
        tc.view.backgroundColor = .systemBackground
        tc.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height-90)
        return tc
    }
    
    // close and tutorial check
    @IBAction func exit(_ sender: Any) {
        let ud = UserDefaults.standard
        ud.set(true, forKey: UserInfoKey.tutorial) // true : 앱 설치후 처음에만 튜토리얼 화면 작동
        ud.synchronize()
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        // 현재 뷰 컨트롤러의 인덱스를 가져옵니다.
        guard var index = (viewController as! TutorialContents).pageIndex else { return nil }
        
        // 인덱스를 감소시키고, 무제한 스크롤을 위해 모듈러 연산을 사용합니다.
        index = (index - 1 + self.tutorialTitles.count) % self.tutorialTitles.count
        
        // 새로운 인덱스의 뷰 컨트롤러를 반환합니다.
        return self.getContentVC(atIndex: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        // 현재 뷰 컨트롤러의 인덱스를 가져옵니다.
        guard var index = (viewController as! TutorialContents).pageIndex else { return nil }
        
        // 인덱스를 증가시키고, 무제한 스크롤을 위해 모듈러 연산을 사용합니다.
        index = (index + 1) % self.tutorialTitles.count
        
        // 새로운 인덱스의 뷰 컨트롤러를 반환합니다.
        return self.getContentVC(atIndex: index)
    }
    
    // 인디 케이터 초기 값, 페이지 뷰 컨트롤러가 최초에 출력할 콘텐츠 부의 인덱스를 알려주는 메서드
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    // 인디 케이터에 표시할 페이지 갯수, 페이지 뷰 컨트롤러가 출력할 페이지의 개수를 알려줄 메서드
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.tutorialTitles.count
    }
}

// 프로퍼티 리스트
struct UserInfoKey {
    static let tutorial = "TUTORIAL"
}
