//
//  Stopwatch.swift
//  Timer
//
//  Created by Wonji Ha on 2022/06/16.
//

/** Reference
 * https://dev200ok.blogspot.com/2020/06/swift-30-projects-02-ios-stopwatch.html 스톱워치 예제
 */

import Foundation
import UIKit
import AVFoundation //햅틱
import UserNotifications
import SystemConfiguration
import GoogleMobileAds

class Stopwatch: UIViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var milliSecLabel: UILabel!
    
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var recordResetButton: UIButton!
    
    @IBOutlet weak var lapsTableView: UITableView!
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    var timer = Timer()
    var startTime = Date()
    var stopWatchStatus : Bool = false // 타이머 상태
    
    var remainTime : Double = 0
    var elapsed : Double = 0 // 경과시간
    var count : Double = 0
    
    var hour = 0
    var minute = 0
    var second = 0
    var milliSecond = 0
    
    var recordList: [String] = [] // 스톱워치 시간 기록 배열
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        lapsTableView.delegate = self
        lapsTableView.dataSource = self
        self.navigationController?.navigationBar.topItem?.title="AD" //뷰 제목
        
        /* Admob */
        //  bannerView.adUnitID = "ca-app-pub-7875242624363574/7192134359"
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716" //테스트 광고
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func stopWatchStartStop(_ sender: Any)
    {
        startTime = Date()
        if (stopWatchStatus)
        {
            btnEffect()
            stopWatchStatus = false
            count = elapsed - count // 일시정지 동안 경과된 시간(흐르는 시간)을 저장된 시간에서 빼준다.
            timer.invalidate()
            startStopButton.setTitle(String(format: NSLocalizedString("시작", comment: "Start")), for: .normal)
            recordResetButton.setTitle(String(format: NSLocalizedString("초기화", comment: "Reset")), for: .normal)
            
        }
        else
        {
            btnEffect()
            stopWatchStatus = true
            startStopButton.setTitle(String(format: NSLocalizedString("일시중지", comment: "Pause")), for: .normal)
            recordResetButton.setTitle(String(format: NSLocalizedString("기록", comment: "Rap")), for: .normal)
            print("일시정지")
            DispatchQueue.main.async {
                // Timer카운터 쓰레드 적용
                self.timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(self.timerCounter), userInfo: nil, repeats: true)
            }
            RunLoop.current.run() // 다른 작업을 실행해도 타이머는 돌아간다(Ex.LAP 테이블을 스크롤시 타이머가 안멈춤.)
        }
    }
    
    @objc private func timerCounter() -> Void
    {
        let timeInterval = Date().timeIntervalSince(startTime)
        remainTime = count + timeInterval // 남은시간 계산
        elapsed = count + remainTime
        
        /** ceil(값) = 소수점 올림  floor(값) = 소수점 내림  trunc(값) = 소수점 버림  round(값) = 소수점 반올림     */
        
        hour = (Int)(fmod((remainTime/60/60), 100)) // 분을 12로 나누어 시를 구한다
        minute = (Int)(fmod((remainTime/60), 60)) // 초를 60으로 나누어 분을 구한다
        second = (Int)(fmod(remainTime, 60)) // 초를 구한다
        milliSecond = (Int)((remainTime - floor(remainTime))*1000)
        
        timeLabel.text = String(format: "%02d:", hour)+String(format: "%02d:", minute)+String(format: "%02d.", second)
        milliSecLabel.text = String(format: "%03d", milliSecond)
    }
    
    @IBAction func recordResetButton(_ sender: Any)
    {
        
        if (stopWatchStatus == true) {
            
            let record = "\(hour):\(minute):\(second):\(milliSecond)" //스톱워치 시간을 기록
            recordList.append(record)
            lapsTableView.reloadData()
            //            tableViewScroll() // 첫번째 기록으로 자동 스크롤
            
            print("스톱워치 기록: ", recordList)
            print("스톱워치 기록 횟수 : ", recordList.count)
            
        }
        else {
            reset() // 초기화 함수 호출
        }
    }
    
    func reset()
    {
        stopWatchStatus = false
        timer.invalidate()
        count = 0
        remainTime = 0
        elapsed = 0
        recordList.removeAll() // 스톱워치 기록 배열 초기화
        lapsTableView.reloadData() // 스톱워치 랩 테이블 초기화
        
        startStopButton.setTitle(String(format: NSLocalizedString("시작", comment: "Start")), for: .normal)
        recordResetButton.setTitle(String(format: NSLocalizedString("기록", comment: "Rap")), for: .normal)
        
        timeLabel.text = "00:00:00."
        milliSecLabel.text = "000"
        print("초기화 되었습니다.")
        
    }
    
    func btnEffect() /* 버튼을 누를때 발생하는 효과 */
    {
        if(SettingTableCell.vibrationCheck == true)
        {
            print("진동: ",SettingTableCell.vibrationCheck)
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred() // 탭틱 엔진이 있는 경우만 작동, 진동세기 강하게
            
        }else{
            print("진동: ",SettingTableCell.vibrationCheck)
        }
        //AudioServicesPlaySystemSound(1016) // 소리발생
    }
    
    private func tableViewScroll() { // 기록 테이블 자동 스크롤 갱신 메소드
        let numberOfSections = lapsTableView.numberOfSections
        let numberOfRows = lapsTableView.numberOfRows(inSection: numberOfSections - 1)
        let lastPath = IndexPath(row: numberOfRows - 1, section: numberOfSections - 1)
        lapsTableView.scrollToRow(at: lastPath, at: .none, animated: true)
    }
}
