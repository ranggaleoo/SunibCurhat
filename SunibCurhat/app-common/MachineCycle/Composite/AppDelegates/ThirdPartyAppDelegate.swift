//
//  ThirdPartyAppDelegate.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 28/02/21.
//  Copyright © 2021 Rangga Leo. All rights reserved.
//

import UIKit
//import GoogleMobileAds
import IQKeyboardManagerSwift
import Siren
import StoreKit
import Cloudinary

class ThirdPartyAppDelegate: AppDelegateType {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        IQKeyboardManager.shared.enable = true
        checkVersionSiren()
//        GADMobileAds.sharedInstance().start(completionHandler: nil)
        requestReviewAppStore()
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        SocketService.shared.connect()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        SocketService.shared.disconnect()
    }
}

extension ThirdPartyAppDelegate {
    private func checkVersionSiren() {
        let siren = Siren.shared
        let rules = RulesManager(majorUpdateRules: .critical, minorUpdateRules: .annoying, patchUpdateRules: .default, revisionUpdateRules: .relaxed, showAlertAfterCurrentVersionHasBeenReleasedForDays: 0)
        siren.rulesManager = rules
        siren.wail()
    }
    
    private func requestReviewAppStore() {
        let timesAccess = UDHelpers.shared.getInt(key: .counterUserAccessApp)
        
        if timesAccess == ConstGlobal.TIMES_REQUEST_REVIEW {
            if #available(iOS 10.3, *) {
                SKStoreReviewController.requestReview()
            } else {
                // Fallback on earlier versions
            }
            UDHelpers.shared.set(value: 0, key: .counterUserAccessApp)
        
        } else {
            UDHelpers.shared.set(value: timesAccess + 1, key: .counterUserAccessApp)
        }
    }
}
