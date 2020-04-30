//
//  GADBannerTableViewCell.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 02/09/19.
//  Copyright © 2019 Rangga Leo. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds

class GADBannerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bannerView: GADBannerView!
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
            self.bannerView.isHidden = true
            self.bannerView.delegate = self
            self.bannerView.adUnitID = self.timeline?.ad_unit_id
            self.bannerView.rootViewController = self.root
            self.bannerView.load(GADRequest())
        }
    }
}

extension GADBannerTableViewCell: GADBannerViewDelegate {
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.isHidden = false
        print_r(title: "ADMOB RECEIVE", message: nil)
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print_r(title: "ADMOB ERROR", message: error)
    }
    
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print_r(title: "ADMOB WILL PRESENT", message: nil)
    }
    
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print_r(title: "ADMOB WILL DISMISS", message: nil)
    }
    
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print_r(title: "ADMOB DID DISMISS", message: nil)
    }
    
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print_r(title: "ADMOB WILL LEAVE", message: nil)
    }
}
