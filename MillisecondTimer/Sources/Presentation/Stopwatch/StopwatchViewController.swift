//
//  Stopwatch.swift
//  MillisecondTimer
//
//  Created by Wonji Ha on 2022/06/16.
//

import Foundation
import UIKit
import AVFoundation // 햅틱
import UserNotifications
import SystemConfiguration
import GoogleMobileAds

final class StopwatchViewController: UIViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var milliSecLabel: UILabel!
    
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var recordResetButton: UIButton!
    
    @IBOutlet weak var lapsTableView: UITableView!
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    private var stopWatch = Timer()
    private var startTime = Date()
    private var mTimer = Mtimer()
    private var viewModel = StopwatchViewModel()
    
//    var stopWatchStatus : Bool = false // 타이머 상태
//    var remainTime : Double = 0
//    var elapsed : Double = 0 // 경과시간
//    var count : Double = 0
//    
//    var hour = 0
//    var minute = 0
//    var second = 0
//    var milliSecond = 0
    
    var recordList: [String] = [] // 스톱워치 시간 기록 배열
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        lapsTableView.delegate = self
        lapsTableView.dataSource = self
        self.navigationController?.navigationBar.topItem?.title="AD" //뷰 제목
        
        /* Admob */
//        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716" // 테스트 광고
        bannerView.adUnitID = "ca-app-pub-7875242624363574/7192134359"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func stopWatchStartStop(_ sender: Any) {
        if mTimer.status {
            stopWatchPause()
            print("스톱워치 상태: ", mTimer.status)
        }
        else {
            stopWatchPlay()
            print("스톱워치 상태: ", mTimer.status)
        }
    }
   
    func stopWatchPlay() {
       
        btnEffect()
        let startTime = Date()
        mTimer.status = true
        startStopButton.setTitle(String(format: NSLocalizedString("일시중지", comment: "Pause")), for: .normal)
        recordResetButton.setTitle(String(format: NSLocalizedString("기록", comment: "Rap")), for: .normal)
        
        stopWatch = Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true, block: { t in
            let timeInterval = Date().timeIntervalSince(startTime)
//            guard var timer = self.mTimer else { return }
            self.mTimer.remainTime = self.mTimer.count + timeInterval
//            self.remainTime = self.count + timeInterval
            self.mTimer.elapsed = self.mTimer.count + self.mTimer.remainTime
//            self.elapsed = self.count + self.remainTime
            self.viewModel.timeCalculate(self.mTimer.remainTime)
            self.timeLabelText()

            
            DispatchQueue.main.async {
                RunLoop.current.add(self.stopWatch, forMode: .common)
            }
        })
        print("스톱워치 작동")
    }
    
    func stopWatchPause() {
        btnEffect()
        mTimer.status = false
        startStopButton.setTitle(String(format: NSLocalizedString("시작", comment: "Start")), for: .normal)
        recordResetButton.setTitle(String(format: NSLocalizedString("초기화", comment: "Reset")), for: .normal)
        mTimer.count = mTimer.elapsed - mTimer.count
        stopWatch.invalidate()
        print("스톱워치 일시중지")
    }
        
    func timeLabelText() {
        timeLabel.text = String(format: "%02d:", viewModel.hour)+String(format: "%02d:", viewModel.minute)+String(format: "%02d.", viewModel.second)
        milliSecLabel.text = String(format: "%03d", viewModel.milliSecond)
    }
    
    @IBAction func recordResetButton(_ sender: Any)
    {
        
        if (mTimer.status == true) {
            
            let record = "\(viewModel.hour):\(viewModel.minute):\(viewModel.second):\(viewModel.milliSecond)" // 스톱워치 시간을 기록
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
        mTimer.status = false
        stopWatch.invalidate()
        mTimer.count = 0
        mTimer.remainTime = 0
        mTimer.elapsed = 0
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
            
        }
        else {
            print("진동: ",SettingTableCell.vibrationCheck)
        }
    }
    
    private func tableViewScroll() { // 기록 테이블 자동 스크롤 갱신 메소드
        let numberOfSections = lapsTableView.numberOfSections
        let numberOfRows = lapsTableView.numberOfRows(inSection: numberOfSections - 1)
        let lastPath = IndexPath(row: numberOfRows - 1, section: numberOfSections - 1)
        lapsTableView.scrollToRow(at: lastPath, at: .none, animated: true)
    }
}

extension StopwatchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if let Lapnum = cell.viewWithTag(1) as? UILabel {
            Lapnum.text = " \( recordList.count - (indexPath as NSIndexPath).row)"
        }
        
        if let TimeLabel = cell.viewWithTag(2) as? UILabel {
            TimeLabel.text = recordList[recordList.count - (indexPath as NSIndexPath).row - 1]
        }
        
        //        print("기록횟수:",recordList.count)
        return cell
    }
}
