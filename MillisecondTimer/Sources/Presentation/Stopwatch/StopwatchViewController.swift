//
//  Stopwatch.swift
//  MillisecondTimer
//
//  Created by Wonji Ha on 2022/06/16.
//

import UIKit
import AVFoundation // 햅틱
import UserNotifications
import SystemConfiguration

final class StopwatchViewController: UIViewController {
    
    @IBOutlet weak var adView: UIView!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var milliSecLabel: UILabel!
    
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var recordResetButton: UIButton!
    
    @IBOutlet weak var lapsTableView: UITableView!
    
    private var stopWatch: Timer?
    private var startTime = Date()
    //    private var mTimer = Mtimer()
    private var viewModel = StopwatchViewModel()
    private let adsManager = AdsManager()
    
    //    var stopWatchStatus : Bool = false // 타이머 상태
    //    var remainTime : Double = 0
    //    var elapsed : Double = 0 // 경과시간
    //    var count : Double = 0
    //
    //    var hour = 0
    //    var minute = 0
    //    var second = 0
    //    var milliSecond = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lapsTableView.delegate = self
        lapsTableView.dataSource = self
        self.navigationController?.navigationBar.topItem?.title="AD" //뷰 제목
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        adsManager.rootViewController = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func stopWatchStartStop(_ sender: Any) {
        if viewModel.mTimer.status {
            stopWatchPause()
            print("스톱워치 상태: ", viewModel.mTimer.status)
        }
        else {
            stopWatchPlay()
            print("스톱워치 상태: ", viewModel.mTimer.status)
        }
    }
    
    private func stopWatchPlay() {
        
        btnEffect()
        let startTime = Date()
        startStopButton.setTitle(String(format: NSLocalizedString("일시중지", comment: "Pause")), for: .normal)
        recordResetButton.setTitle(String(format: NSLocalizedString("기록", comment: "Rap")), for: .normal)
        
        stopWatch = Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true, block: { t in
            let timeInterval = Date().timeIntervalSince(startTime)
            self.viewModel.timeCalculate(timeInterval)
            self.timeLabelText()
            
            DispatchQueue.main.async {
                RunLoop.current.add(self.stopWatch!, forMode: .common)
            }
        })
        print("스톱워치 작동")
    }
    
    private func stopWatchPause() {
        btnEffect()
        startStopButton.setTitle(String(format: NSLocalizedString("시작", comment: "Start")), for: .normal)
        recordResetButton.setTitle(String(format: NSLocalizedString("초기화", comment: "Reset")), for: .normal)
        viewModel.timePauseCalculate()
        stopWatch?.invalidate()
        print("스톱워치 일시중지")
    }
    
    private func timeLabelText() {
        timeLabel.text = "\(viewModel.timeText)"
        milliSecLabel.text = viewModel.milliSecond
    }
    
    @IBAction func recordResetButton(_ sender: Any) {
        if (viewModel.mTimer.status == true) {
            viewModel.addRecord()
            lapsTableView.reloadData()
            //            tableViewScroll() // 첫번째 기록으로 자동 스크롤
        }
        else {
            resetButtonTapped() // 초기화 함수 호출
        }
    }
    
    private func resetButtonTapped() {
        stopWatch?.invalidate()
        viewModel.resetRecords()
        lapsTableView.reloadData() // 스톱워치 랩 테이블 초기화
        
        startStopButton.setTitle(String(format: NSLocalizedString("시작", comment: "Start")), for: .normal)
        recordResetButton.setTitle(String(format: NSLocalizedString("기록", comment: "Rap")), for: .normal)
        
        timeLabel.text = "00:00:00."
        milliSecLabel.text = "000"
        print("초기화 되었습니다.")
    }
    
    private func btnEffect() {
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
        return viewModel.recordList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if let Lapnum = cell.viewWithTag(1) as? UILabel {
            Lapnum.text = " \( viewModel.recordList.count - (indexPath as NSIndexPath).row)"
        }
        
        if let TimeLabel = cell.viewWithTag(2) as? UILabel {
            TimeLabel.text = viewModel.recordList[viewModel.recordList.count - (indexPath as NSIndexPath).row - 1]
        }
        return cell
    }
}

extension StopwatchViewController: AdSimpleBannerPowered {
    func addBannerToAdsPlaceholder(_ banner: UIView) {
        
        banner.translatesAutoresizingMaskIntoConstraints = false
        adView.addSubview(banner)
        banner.topAnchor.constraint(equalTo: adView.topAnchor).isActive = true
        banner.heightAnchor.constraint(equalTo: adView.heightAnchor).isActive = true
        banner.leadingAnchor.constraint(equalTo: adView.leadingAnchor).isActive = true
        banner.trailingAnchor.constraint(equalTo: adView.trailingAnchor).isActive = true
    }
}
