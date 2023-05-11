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

    @IBOutlet weak var exitButton: UIButton!

    var pageVC : UIPageViewController!
    var pageControl : UIPageControl!
    var tutorialTitles = ["환영합니다!", "+를 눌러서 시간을 추가해보세요!", "-를 눌러서 시간을 빼보세요."]
    var tutorialImages = ["1", "2", ""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        /// page view controller 속성 정의
        pageVC = instanceTutorial(name: "PageVC") as? UIPageViewController
        pageVC.dataSource = self
        
        /// page view controller에서 페이지가 될 부분 삽입
        let startTutorial = self.getContentVC(atIndex: 0)! // as! TutorialContents
        
        /// 스와이프 할 때마다 이 배열에 하나씩 추가 됨
        pageVC.setViewControllers([startTutorial], direction: .forward, animated: true)
        pageVC.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 90)
        //        pageVC.view.frame.origin = CGPoint(x: 0, y: 0)
        //        self.pageVC.view.frame.size.width = self.view.frame.width
        //        self.pageVC.view.frame.size.height = self.view.frame.height - 90
        
        // pageView 컨트롤러를 마스터 뷰 컨트롤러의 자식으로 설정
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
        
        
        // page indicator 외형 템플릿
        pageControl = UIPageControl.appearance()
        pageControl.pageIndicatorTintColor = UIColor.systemGray
        pageControl.currentPageIndicatorTintColor = UIColor.systemBlue
        pageControl.backgroundColor = .systemBackground
    }

    /// 표현하려는 컨텐츠 뷰에 내용을 세팅한 후, DataSource이벤트에서 사용될 뷰컨트롤러 반환
    func getContentVC(atIndex idx: Int) -> UIViewController? {
        
        // index 범위 체크
        guard tutorialTitles.count > idx && tutorialTitles.count > 0 else { return nil }
        let cvc = TutorialContents()
//        guard let cvc = instanceTutorial(name: "TutorialVC") as? TutorialContents else { return nil }
        cvc.titleText = tutorialTitles[idx]
        cvc.imageFile = tutorialImages[idx]
        cvc.pageIndex = idx
        cvc.view.backgroundColor = .brown
//        cvc.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height-90)
        return cvc
    }
//    @IBAction func pageChanged(_ sender: UIPageControl) {
//        bgImageView.image = UIImage(named: imageFile)
//    }
    /// close and tutorial check
    @IBAction func exit(_ sender: Any) {
        let ud = UserDefaults.standard
        ud.set(true, forKey: UserInfoKey.tutorial)
        ud.synchronize()
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    // 현재의 콘텐츠 뷰 컨트롤러보다 앞쪽에 올 콘텐츠 뷰 컨트롤러 객체
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            // 현재 페이지 인덱스
        guard var index = (viewController as! TutorialContents).pageIndex else { return nil }
        
            // 인덱스가 맨 앞이면 nil
            guard index > 0 else { return nil }
            
            // 이전 페이지 인덱스
            index -= 1
            return self.getContentVC(atIndex: index)
        }
        
        // 현재의 콘텐츠 뷰 컨트롤러 뒤쪽에 올 콘텐츠 뷰 컨트롤러 객체
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            // 현재 페이지 인덱스
            guard var index = (viewController as! TutorialContents).pageIndex else { return nil }
            
            // 다음 페이지 인덱스
            index += 1
            
            // 인덱스는 배열 데이터의 크기보다 작아야함
            guard index < self.tutorialTitles.count else { return nil }
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

extension UIViewController {
    var mainSb: UIStoryboard {
           return UIStoryboard(name: "Main", bundle: Bundle.main)
       }
       func instanceTutorial(name: String) -> UIViewController? {
           return self.mainSb.instantiateViewController(withIdentifier: name)
       }
   }


