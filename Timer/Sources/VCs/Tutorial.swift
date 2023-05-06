//
//  Tutorial.swift
//  Timer
//
//  Created by Wonji Ha on 2023/05/06.
//
/** Reference
 * https://blog.naver.com/nanocode-/221386395463 튜토리얼 화면 만들기 (2) (스토리보드 분리 / 페이지 뷰 컨트롤러)
 * https://ios-development.tistory.com/80 튜토리얼 화면(tutorial screen) 만들기 - PageViewController (programmatically)
 *
 */
import UIKit

class Tutorial: UIViewController, UIPageViewControllerDataSource {
    
    var window: UIWindow?

    var pageVC : UIPageViewController!
    var pageControl : UIPageControl!
    @IBOutlet weak var exitBtn: UIButton!
//    var exitBtn : UIButton!
    
    var tutorialTitle = ["first", "two"]
    var tutorialImages = ["1", "2"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// page view controller 속성 정의
        pageVC = instanceTutorialVC(name: "PageVC") as? UIPageViewController
        pageVC.dataSource = self
        
        /// page view controller에서 페이지가 될 부분 삽입
        let startTutorial = getContentVC(atIndex: 0)! //as! TutorialContents
        
        /// 스와이프 할 때마다 이 배열에 하나씩 추가 됨
        pageVC.setViewControllers([startTutorial], direction: .forward, animated: true)
//        pageVC.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 90)
        pageVC.view.frame.origin = CGPoint(x: 0, y: 0)
        self.pageVC.view.frame.size.width = self.view.frame.width
        self.pageVC.view.frame.size.height = self.view.frame.height - 90
        
        // pageView 컨트롤러를 마스터 뷰 컨트롤러의 자식으로 설정
        /// 3단계 암기할 것
        self.addChild(pageVC)
        self.view.addSubview(pageVC.view)
        pageVC.didMove(toParent: self) // 자식 뷰 컨트롤러에게 부모 뷰 컨트롤러가 바뀌었음을 알림
        
//        exitBtn = UIButton()
//        exitBtn.setTitle("닫기", for: .normal)
//        exitBtn.setTitleColor(.blue, for: .normal)
//        exitBtn.setTitleColor(.green, for: .selected)
//        exitBtn.addTarget(self, action: #selector(close(_:)), for: .touchUpInside)
//        exitBtn.frame = CGRect(x: 50, y: 50, width: 50, height: 30)
//        view.addSubview(exitBtn)

        
        /// page indicator
        pageControl = UIPageControl.appearance()
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .blue
        pageControl.backgroundColor = .darkGray
        
    }
    
    /// 표현하려는 컨텐츠 뷰에 내용을 세팅한 후, DataSource이벤트에서 사용될 뷰컨트롤러 반환
    func getContentVC(atIndex idx: Int) -> UIViewController? {
        
        // index 범위 체크
        guard self.tutorialTitle.count >= idx && self.tutorialTitle.count > 0 else {
            return nil
        }
        
        guard let cvc = instanceTutorialVC(name: "ContentsVC") as? TutorialContents else {
            return nil
        }
        cvc.titleText = tutorialTitle[idx]
        cvc.imageFile = tutorialImages[idx]
        cvc.pageIndex = idx
        cvc.view.backgroundColor = .brown
//        cvc.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height-90)
        return cvc
    }
    
    /// close and tutorial check
    @IBAction func close(_ sender: Any) {
        let ud = UserDefaults.standard
        ud.set(true, forKey: UserInfoKey.tutorial)
        ud.synchronize()
        self.presentingViewController?.dismiss(animated: true)
//        dismiss(animated: true, completion: nil)

    }
    
    
    // 현재의 콘텐츠 뷰 컨트롤러보다 앞쪽에 올 콘텐츠 뷰 컨트롤러 객체
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            // 현재 페이지 인덱스
            guard var index = (viewController as! TutorialContents).pageIndex else {
                return nil
            }
            // 인덱스가 맨 앞이면 nil
            guard index > 0 else {
                return nil
            }
            
            // 이전 페이지 인덱스
            index -= 1
            return self.getContentVC(atIndex: index)
        }
        
        // 현재의 콘텐츠 뷰 컨트롤러 뒤쪽에 올 콘텐츠 뷰 컨트롤러 객체
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            // 현재 페이지 인덱스
            guard var index = (viewController as! TutorialContents).pageIndex else {
                return nil
            }
            
            // 다음 페이지 인덱스
            index += 1
            
            // 인덱스는 배열 데이터의 크기보다 작아야함
            guard index < self.tutorialTitle.count else {
                return nil
            }
            
            return self.getContentVC(atIndex: index)
        }
    
    // 인디 케이터에 표시할 페이지 갯수
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.tutorialTitle.count
    }
    
    // 인디 케이터 초기 값
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
}

//extension Tutorial: UIPageViewControllerDataSource {
//
//    // will be appered when "left" swipe the screen
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
//
//        guard var index = (viewController as! TutorialContents).pageIndex else {return nil}
//
//        guard index > 0 else {return nil}
//
//        index -= 1 // front page
//
//        return self.getContentVC(atIndex: index)
//    }
//
//    // will be appered when "right" swipe the screen
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
//
//        guard var index = (viewController as! TutorialContents).pageIndex else {return nil}
//
//        index += 1 // rear page
//
//        guard index < self.tutorialTitle.count else {return nil}
//
//        return self.getContentVC(atIndex: index)
//    }
//

//

//}


