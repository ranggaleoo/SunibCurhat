//
//  AppDelegate.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 04/08/19.
//  Copyright © 2019 Rangga Leo. All rights reserved.
//

import UIKit
import CoreData
import GoogleMobileAds
import Firebase
import IQKeyboardManagerSwift
import Siren

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appDelegate: AppDelegateType? = nil

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.appDelegate = AppDelegateFactory.makeDefault(window: self.window)
        _ = appDelegate?.application?(application, didFinishLaunchingWithOptions: launchOptions)
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        _ = appDelegate?.applicationWillTerminate?(application)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        _ = appDelegate?.application?(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
    }
}
