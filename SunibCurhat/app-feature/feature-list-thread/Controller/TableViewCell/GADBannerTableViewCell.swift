//
//  GADBannerTableViewCell.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 02/09/19.
//  Copyright © 2019 Rangga Leo. All rights reserved.
//

import Foundation
import UIKit
//import GoogleMobileAds

class GADBannerTableViewCell: UITableViewCell {
    
//    @IBOutlet weak var bannerView: GADBannerView!
    var root: UIViewController!
    
    var timeline: TimelineItems? {
        didSet {
            self.updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    private func updateUI() {
        DispatchQueue.main.async {
//            self.bannerView.isHidden = true
//            self.bannerView.delegate = self
//            self.bannerView.adUnitID = self.timeline?.ad_unit_id
//            self.bannerView.rootViewController = self.root
//            self.bannerView.load(GADRequest())
        }
    }
}

//extension GADBannerTableViewCell: GADBannerViewDelegate {
//    // request lifecycle
//    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
//        bannerView.isHidden = false
//        debugLog(#function)
//    }
//    
//    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
//        debugLog(#function)
//    }
//    
//    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
//        debugLog(#function)
//    }
//    
//    //click-time lifecycle
//    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
//        debugLog(#function)
//    }
//    
//    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
//        debugLog(#function)
//    }
//    
//    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
//        debugLog(#function)
//    }
//}
