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
    
    public func set(value defaultValue: Any, key defaultKey: String) {
        defaults?.set(defaultValue, forKey: defaultKey)
    }
    
    public func getBool(key defaultKey: String) -> Bool {
        if let result = defaults?.object(forKey: defaultKey) as? Bool {
            return result
        }
        return false
    }
    
    public func getInt(key defaultKey: String) -> Int {
        if let result = defaults?.object(forKey: defaultKey) as? Int {
            return result
        }
        return 0
    }
    
    public func getDouble(key defaultKey: String) -> Double {
        if let result = defaults?.object(forKey: defaultKey) as? Double {
            return result
        }
        return 0.0
    }
    
    public func getFloat(key defaultKey: String) -> Float {
        if let result = defaults?.object(forKey: defaultKey) as? Float {
            return result
        }
        return 0.0
    }
    
    public func getUrl(key defaultKey: String) -> URL {
        if let result = defaults?.object(forKey: defaultKey) as? URL {
            return result
        }
        return URL(string: "https://google.com/")!
        
    }
}
