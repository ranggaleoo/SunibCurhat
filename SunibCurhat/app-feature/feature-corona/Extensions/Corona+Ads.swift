//
//  Corona+Ads.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 03/05/20.
//  Copyright © 2020 Rangga Leo. All rights reserved.
//

import Foundation
import GoogleMobileAds

extension CoronaController: GADBannerViewDelegate {
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.isHidden = false
        print_r(title: "ADMOB RECEIVE", message: nil)
    }
}
