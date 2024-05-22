//
//  AdsManager.swift
//  MillisecondTimer
//
//  Created by Wonji Ha on 2024/05/09.
//

import UIKit
import GoogleMobileAds

protocol AdSimpleBannerPowered: UIViewController {
    func addBannerToAdsPlaceholder(_ banner: UIView)
}

private struct AdsConstants {
    static let adBottomBannerUnitID = "ca-app-pub-7875242624363574/7192134359"
}

final class AdsManager : NSObject {
    var loadedSimpleBannerAd = false
    private(set) var bannerView: GADBannerView?
    var rootViewController: UIViewController? {
        didSet {
            setupSimpleBannerAdsIfPossible()
        }
    }

    public override init() {
        super.init()
        GADMobileAds.sharedInstance().start()
        configureSimpleBanner()
    }
    
    private func configureSimpleBanner() {
        bannerView = GADBannerView(adSize: GADAdSizeBanner)
        bannerView?.delegate = self
        bannerView?.adUnitID = AdsConstants.adBottomBannerUnitID
    }
    
    private func setupSimpleBannerAdsIfPossible() {
        assert(self.bannerView != nil, "WTF: simple banner has not been configured (call Ads.configure() before any usage)!")
        if let root = rootViewController as? AdSimpleBannerPowered {
            if let banner = self.bannerView {
                banner.rootViewController = root
                if !loadedSimpleBannerAd {
                    banner.load(GADRequest())
                } else {
                    root.addBannerToAdsPlaceholder(banner)
                }
            }
        }
    }
}

extension AdsManager : GADBannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.alpha = 1
        print("adViewDidReceiveAd")
        loadedSimpleBannerAd = true
        if let root = rootViewController as? AdSimpleBannerPowered {
            root.addBannerToAdsPlaceholder(bannerView)
        }
    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
}
