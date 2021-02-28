//
//  AppDelegateFactory.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 28/02/21.
//  Copyright © 2021 Rangga Leo. All rights reserved.
//

import UIKit

enum AppDelegateFactory {
    static func makeDefault(window: UIWindow? = nil) -> AppDelegateType {
        return CompositeAppDelegate(appDelegates: [
            StartupAppDelegate(window: window),
            CoreDataAppDelegate(),
            ThirdPartyAppDelegate(),
            NotificationAppDelegate()
        ])
    }
}
