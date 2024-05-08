//
//  Setting.swift
//  MillisecondTimer
//
//  Created by WONJI HA on 2021/10/22.
//

import UIKit

final class Setting: UIViewController { // UITableViewDataSource, UITableViewDelegate
    
    private let adsManager = AdsManager()
    @IBOutlet weak var adView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        adsManager.rootViewController = self
    }
}

extension Setting: AdSimpleBannerPowered {
    func addBannerToAdsPlaceholder(_ banner: UIView) {
        banner.translatesAutoresizingMaskIntoConstraints = false
        adView.addSubview(banner)
        banner.topAnchor.constraint(equalTo: adView.topAnchor).isActive = true
        banner.heightAnchor.constraint(equalTo: adView.heightAnchor).isActive = true
        banner.leadingAnchor.constraint(equalTo: adView.leadingAnchor).isActive = true
        banner.trailingAnchor.constraint(equalTo: adView.trailingAnchor).isActive = true
    }
}
