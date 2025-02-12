//
//  Reference.md
//  MillisecondTimer
//
//  Created by Wonji Ha on 2023/02/16.
//
/**참고 및 공부**/
/**
 * https://noahlogs.tistory.com/9 [기초]변수와 상수
 * https://80000coding.oopy.io/0bd77cd3-7dc7-4cf4-93ee-8ca4fbca898e 가드문 사용법 (if문보다 빠르게 끝낸다)
 * https://es1015.tistory.com/504 [Swift] FileManager로 디바이스에 파일 저장하기 (Document) [LSSupportsOpeningDocumentsInPlace entry or an UISupportsDocumentBrowser entry to your Info.plist to declare support.]
 * https://velog.io/@brillantescene/%EC%8A%A4%EC%9C%84%ED%94%84%ED%8A%B8-%ED%8C%8C%EC%9D%BC-%EC%A0%95%EB%A6%AC 프로젝트 구조 정리1
 * https://mini-min-dev.tistory.com/15 프로젝트 구조 정리2(프로젝트 폴더링)
 * https://www.clien.net/service/board/cm_app/17167370 클리앙 개발 문의
 옵셔널 체이닝: 변수나 상수 뒤에 ? 또는 !느낌표를 사용하여 옵셔널에서 값을 강제 추출하는 효과가 있다. 사용을 지양하는 편이 좋다고 한다.
 * https://fomaios.tistory.com/entry/Swift-Enum%EC%97%B4%EA%B1%B0%ED%98%95%EC%9D%84-%EC%8D%A8%EC%95%BC-%ED%95%98%EB%8A%94-%EC%9D%B4%EC%9C%A0 Enum 열거형 이란?
 * https://pskbhnsr.tistory.com/48 딕셔너리 정렬
 * https://junyng.tistory.com/30 Dynamic Type을 사용하여 폰트 크기 조정하기
 * https://velog.io/@2004jmk/Background%EC%97%90%EC%84%9C-%EC%95%B1-%EA%B3%84%EC%86%8D%ED%95%B4%EC%84%9C-%EC%8B%A4%ED%96%89%ED%95%98%EA%B8%B0-Swift Background에서 앱 계속해서 실행하기
 * https://icksw.tistory.com/178 Foreground, Background 알아보기
 * https://ohwhatisthis.tistory.com/21 프로젝트 폴더 변경후 컴파일 Info.plist'. Error 에러
 * https://babbab2.tistory.com/124 extension(확장)이란?
 * http://yoonbumtae.com/?p=4642 로컬 푸시 알림 메시지
 * https://fomaios.tistory.com/entry/iOS-%ED%91%B8%EC%89%AC-%EC%95%8C%EB%A6%BC-%ED%83%AD%ED%96%88%EC%9D%84-%EB%95%8C-%ED%8A%B9%EC%A0%95-%ED%8E%98%EC%9D%B4%EC%A7%80%EB%A1%9C-%EC%9D%B4%EB%8F%99%ED%95%98%EA%B8%B0 푸시알림 탭 특정뷰 이동(APN 네트워크 이용시)
 * https://velog.io/@yoonjong/Swift-Push-Notification-%EB%88%84%EB%A5%BC-%EB%95%8C-%ED%8A%B9%EC%A0%95-ViewController-%EB%9C%A8%EA%B2%8C-%ED%95%98%EA%B8%B0 푸시알림 특정뷰 이동(새뷰에서)
 * https://velog.io/@minji0801/iOS-Swift-%EC%95%B1-%EC%B6%94%EC%A0%81-%EA%B6%8C%ED%95%9C-Alert-%EB%9D%84%EC%9A%B0%EA%B8%B0 앱 추적 권한 요청
 * https://fomaios.tistory.com/entry/%EC%95%B1-%EC%83%9D%EB%AA%85%EC%A3%BC%EA%B8%B0App-LifeCycle-1?category=851398 - 생명주기
 * https://hururuek-chapchap.tistory.com/149 노티피케이션
 
 * https://inuplace.tistory.com/1163 로컬라이징
 * http://yoonbumtae.com/?p=4168 로컬라이제이션 방법
 * https://lxxyeon.tistory.com/133 개발언어 한국어로 변경하는 법
 
 * https://s-o-h-a.tistory.com/33 애드몹 사용방법
 * https://stackoverflow.com/questions/61933279/how-to-have-admob-ads-in-multiple-viewcontrollers-swift-xcode 애드몹 여러뷰에서 1번만 호출하기(코드중복 제거)

 *
 /** stopwatch
 * https://dev200ok.blogspot.com/2020/06/swift-30-projects-02-ios-stopwatch.html 스톱워치 예제
 * https://seorenn.blogspot.com/2018/05/swift-result-of-call-is-unused.html @discardableResult 사용하기 Result of call to ... is unused
 */

/** Timer
 * ceil(값) = 소수점 올림  floor(값) = 소수점 내림  trunc(값) = 소수점 버림  round(값) = 소수점 반올림
 *
 * https://unclean.tistory.com/27 타이머3 시작시간 카운트
 * https://ios-development.tistory.com/773 타이머4
 * https://ios-development.tistory.com/775 DispatchSourceTimer를 이용한 Timer 모듈 구현
 * https://80000coding.oopy.io/0bd77cd3-7dc7-4cf4-93ee-8ca4fbca898e 가드문 사용법 (if문보다 빠르게 끝낸다)
 * https://jesterz91.github.io/ios/2021/04/07/ios-notification/ UserNotification 프레임워크를 이용한 알림구현
 * https://twih1203.medium.com/swift-usernotification%EC%9C%BC%EB%A1%9C-%EC%9D%B4%EB%AF%B8%EC%A7%80%EA%B0%80-%ED%8F%AC%ED%95%A8%EB%90%9C-%EB%A1%9C%EC%BB%AC-%EC%95%8C%EB%A6%BC-%EB%B3%B4%EB%82%B4%EA%B8%B0-5a7ef07fa2ec UserNotification으로 이미지가 포함된 로컬 알림 보내기
 * https://gonslab.tistory.com/27 푸시 알림 권한
 * https://boidevelop.tistory.com/62?category=839928 텍스트 필드 개념
 * https://scshim.tistory.com/220 UIAlert 알림창 구현
 * https://boidevelop.tistory.com/57 알림창 텍스트필드 추가
 * https://stackoverflow.com/questions/33658521/how-to-make-a-uilabel-clickable UILable 터치이벤트
 * https://stackoverflow.com/questions/1080043/how-to-disable-multitouch 버튼 멀티터치 막기
 * https://stackoverflow.com/questions/42319172/swift-3-how-to-make-timer-work-in-background 백그라운드 타이머 작동?
 * https://paul-goden.tistory.com/11 타이머 백그라운드 참고
 * https://eun-dev.tistory.com/24 노티 제거

 */
 
 /** Setting
 https://philosopher-chan.tistory.com/1032 테이블 셀 클릭 이벤트 처리
 https://stackoverflow.com/questions/37558333/select-cell-in-tableview-section 테이블 섹션 구분
 https://sweetdev.tistory.com/105 셀 선택시 바로 deselect 시켜버리기
 https://velog.io/@minji0801/iOS-Swift-iOS-%EA%B8%B0%EA%B8%B0%EC%97%90%EC%84%9C-Mail-%EC%95%B1-%EC%9D%B4%EC%9A%A9%ED%95%B4%EC%84%9C-%EC%9D%B4%EB%A9%94%EC%9D%BC-%EB%B3%B4%EB%82%B4%EB%8A%94-%EB%B0%A9%EB%B2%95 메일 보내기
 https://borabong.tistory.com/6 메일컨트롤러 dismiss
 https://www.reddit.com/r/swift/comments/wsvmse/id_like_to_make_the_uiswitch_be_in_the_on/ 앱 처음 설치시 스위치 켜짐 상태
 https://0urtrees.tistory.com/344 StoreKit, iOS앱 리뷰유도 기능 requestReview deprecated 경고 해결방법
 https://stackoverflow.com/questions/63953891/requestreview-was-deprecated-in-ios-14-0 앱 리뷰 경고 해결방법2
 https://zeddios.tistory.com/107  UserDefaults 사용하여 데이터 저장
 https://babbab2.tistory.com/119 소리 확인 변수 *static 프로퍼티를 사용해야 값이 수정된다.
 
 */
 
/** InfoViewController
https://scshim.tistory.com/77 UITextView
https://withthemilkyway.tistory.com/31 텍스트뷰 설명
 
 */
 
 /** TutorialViewController
 * https://blog.naver.com/nanocode-/221386395463 튜토리얼 화면 만들기 (2) (스토리보드 분리 / 페이지 뷰 컨트롤러)
 * https://ios-development.tistory.com/80 튜토리얼 화면(tutorial screen) 만들기 - PageViewController (programmatically)
 */
 
 /** TutorialContents
 * https://kkh0977.tistory.com/2753 CGRect 사용해 x , y , width , height 좌표, 크기 설정 및 동적으로 UILabel 라벨 생성 실시
 * https://woongsios.tistory.com/57 status bar 높이 구하기 in Swift 5
 * https://stackoverflow.com/questions/15057471/how-can-i-get-my-app-in-open-with 내부 파일 추가시 Info.plist CFBundleDocumentTypes 항목에 추가해야함(gif)
 * https://mrgamza.tistory.com/645 CFBundleDocumentTypes에 대해서
 */
 
/**
 3. ViewModel (뷰 모델):
 ViewModel = Model 데이터를 View에 맞게 가공 및 처리 (뷰에 반영될 데이터 비즈니스 로직 담당)

 뷰와 모델 사이의 중간 계층으로, 비즈니스 로직을 처리하고 뷰에 표시할 데이터를 가공한다. 뷰 모델은 뷰에 데이터를 제공하고, 사용자 입력을 처리하여 모델과 상호작용한다. View로부터 전달받는 요청을 처리할 로직을 담고 있으며 Model에 변화가 생기면 View에 notification을 보낸다. (데이터의 변화를 View가 알아챌 수 있도록 한다고 생각하면 된다) ViewModel은 View와 Model 사이의 중개자 역할을 하며 Presentation Logic을 처리하는 역할을 한다.
 
 앱의 핵심적인 비즈니스 로직을 담고 있는 코드의 계층이다. MVC 패턴의 Controller와 비슷한 역할. View와 Model의 사이에서 View의 요청에 따라 로직을 실행하고, Model의 변화에 따라 데이터를 처리하여 View를 refresh한다.

 Model에 변화가 생기면 View에게 notification을 보내는 역할을 한다. 또한, View로부터 전달받는 요청을 해결할 비즈니스 로직을 담는다. ViewModel은 UI 관련 코드로부터 완전히 분리되어있고, 따라서 ViewModel 파일에는 SiwftUI같은 UI 프레임워크를 import하지않아도 된다.

 */
