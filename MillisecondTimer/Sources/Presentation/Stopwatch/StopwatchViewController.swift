//
//  Stopwatch.swift
//  MillisecondTimer
//
//  Created by Wonji Ha on 2022/06/16.
//

import UIKit
import SystemConfiguration

final class StopwatchViewController: UIViewController {
    
    @IBOutlet weak var adView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var milliSecLabel: UILabel!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var recordResetButton: UIButton!
    @IBOutlet weak var lapsTableView: UITableView!
    
    private var viewModel = StopwatchViewModel()
    private let adsManager = AdsManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lapsTableView.delegate = self
        lapsTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        adsManager.rootViewController = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func stopWatchStartStopButtonTapped(_ sender: Any) {
        viewModel.buttonVibrationEffect()
        if viewModel.mTimer.status {
            viewModel.stopWatchPause()
            startStopButton.setTitle(ButtonType.start.name, for: .normal)
            recordResetButton.setTitle(ButtonType.reset.name, for: .normal)
            print("스톱워치 상태: ", viewModel.mTimer.status)
        }
        else {
            viewModel.stopWatchPlay {
                self.timeLabelText()
            }
            startStopButton.setTitle(ButtonType.pause.name, for: .normal)
            recordResetButton.setTitle(ButtonType.rap.name, for: .normal)
            print("스톱워치 상태: ", viewModel.mTimer.status)
        }
    }
    
    private func timeLabelText() {
        timeLabel.text = viewModel.timeText
        milliSecLabel.text = viewModel.milliSecondText
    }
    
    @IBAction func recordResetButtonTapped(_ sender: Any) {
        if (viewModel.mTimer.status == true) {
            viewModel.addRecord()
            lapsTableView.reloadData()
            //            tableViewScroll() // 첫번째 기록으로 자동 스크롤
        }
        else {
            resetButtonTapped()
        }
    }
    
    private func resetButtonTapped() {
        viewModel.resetRecords()
        lapsTableView.reloadData()
        
        startStopButton.setTitle(ButtonType.start.name, for: .normal)
        recordResetButton.setTitle(ButtonType.rap.name, for: .normal)
        
        timeLabel.text = "00:00:00."
        milliSecLabel.text = "000"
        print("초기화 되었습니다.")
    }
    
    private func tableViewScroll() {
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
