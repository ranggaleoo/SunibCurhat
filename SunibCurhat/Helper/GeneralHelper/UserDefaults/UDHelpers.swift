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
    private var defaults: UserDefaults?
    
    init() {
        defaults = UserDefaults.standard
    }
    
    public func set(value defaultValue: Any, key defaultKey: UDHelpersKey) {
        defaults?.set(defaultValue, forKey: defaultKey.rawValue)
    }
    
    public func getString(key defaultKey: UDHelpersKey) -> String {
        if let result = defaults?.object(forKey: defaultKey.rawValue) as? String {
            return result
        }
        return ""
    }
    
    public func getBool(key defaultKey: UDHelpersKey) -> Bool {
        if let result = defaults?.object(forKey: defaultKey.rawValue) as? Bool {
            return result
        }
        return false
    }
    
    public func getInt(key defaultKey: UDHelpersKey) -> Int {
        if let result = defaults?.object(forKey: defaultKey.rawValue) as? Int {
            return result
        }
        return 0
    }
    
    public func getDouble(key defaultKey: UDHelpersKey) -> Double {
        if let result = defaults?.object(forKey: defaultKey.rawValue) as? Double {
            return result
        }
        return 0.0
    }
    
    public func getFloat(key defaultKey: UDHelpersKey) -> Float {
        if let result = defaults?.object(forKey: defaultKey.rawValue) as? Float {
            return result
        }
        return 0.0
    }
    
    public func getUrl(key defaultKey: UDHelpersKey) -> URL {
        if let result = defaults?.object(forKey: defaultKey.rawValue) as? URL {
            return result
        }
        return URL(string: "https://google.com/")!
    }
}

enum UDHelpersKey: String {
    case eulaIsChecked          = "EULA_IS_CHEKED"
    case tmpToken               = "TMP_TOKEN"
    case counterUserAccessApp   = "COUNTER_USER_ACCESS_APP"
}
