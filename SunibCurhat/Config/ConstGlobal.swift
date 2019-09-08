//
//  ConstGlobal.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 04/08/19.
//  Copyright © 2019 Rangga Leo. All rights reserved.
//

import Foundation
import UIKit
import Firebase

struct ConstGlobal {
    static let SERVER_KEY_FCM: String   = "AIzaSyCwS8paxxv_b1CLEJwnuUi6rCM2_3XJr18"
    static let AdMOB_APP_ID: String     = "ca-app-pub-9947251997620985~4316262809"
    static let MINIMUM_TEXT: Int        = 5
}

struct RepoMemory {
    static var token: String? {
        didSet {
            NotificationCenter.default.post(name: .tokenIsChanged, object: nil)
        }
    }
    
    static var token_notif: String?
    static var pendingFunction: (() -> Void)?
    static var user_name: String?
    static let device_id: String = UIDevice.current.identifierForVendor?.uuidString ?? "Unknown"
}
