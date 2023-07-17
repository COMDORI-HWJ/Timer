//
//  Setting.swift
//  Timer
//
//  Created by WONJI HA on 2021/10/22.
//

import Foundation
import UIKit
import GoogleMobileAds

class Setting: UIViewController { // UITableViewDataSource, UITableViewDelegate
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Admob */
        //        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716" // 테스트 광고
        bannerView.adUnitID = "ca-app-pub-7875242624363574/7192134359"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
}
