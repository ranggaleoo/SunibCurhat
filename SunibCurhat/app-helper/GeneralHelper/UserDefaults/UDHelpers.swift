//
//  UDHelpers.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 16/09/19.
//  Copyright © 2019 Rangga Leo. All rights reserved.
//

import Foundation

class UDHelpers {
    static var shared = UDHelpers()
    private var defaults = UserDefaults.standard
    
    init() {
        print("initialize user default")
    }
    
    public func set(value defaultValue: Any, key defaultKey: UDHelpersKey) {
        defaults.set(defaultValue, forKey: defaultKey.rawValue)
    }
    
    public func getString(key defaultKey: UDHelpersKey) -> String {
        if let result = defaults.string(forKey: defaultKey.rawValue) {
            return result
        }
        return ""
    }
    
    public func getBool(key defaultKey: UDHelpersKey) -> Bool {
        return defaults.bool(forKey: defaultKey.rawValue)
    }
    
    public func getInt(key defaultKey: UDHelpersKey) -> Int {
        return defaults.integer(forKey: defaultKey.rawValue)
    }
    
    public func getDouble(key defaultKey: UDHelpersKey) -> Double {
        return defaults.double(forKey: defaultKey.rawValue)
    }
    
    public func getFloat(key defaultKey: UDHelpersKey) -> Float {
        return defaults.float(forKey: defaultKey.rawValue)
    }
    
    public func getUrl(key defaultKey: UDHelpersKey) -> URL {
        if let result = defaults.url(forKey: defaultKey.rawValue) {
            return result
        }
        return URL(string: "https://google.com/")!
    }
}

enum UDHelpersKey: String {
    case eulaIsChecked          = "EULA_IS_CHEKED"
    case tmpToken               = "TMP_TOKEN"
    case counterUserAccessApp   = "COUNTER_USER_ACCESS_APP"
    case isFreeAds
}
