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
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    init() {
        debugLog("initialize user default")
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
    
    func setObject<T: Codable>(_ object: T, forKey defaultKey: UDHelpersKey) {
        do {
            let data = try encoder.encode(object)
            defaults.set(data, forKey: defaultKey.rawValue)
        } catch {
            debugLog("Failed to encode object: \(error)")
        }
    }
    
    func getObject<T: Codable>(type: T.Type, forKey defaultKey: UDHelpersKey) -> T? {
        guard let data = defaults.data(forKey: defaultKey.rawValue) else { return nil }
        do {
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            debugLog("Failed to decode object: \(error)")
            return nil
        }
    }
}

enum UDHelpersKey: String {
    case eulaIsChecked          = "EULA_IS_CHEKED"
    case tmpToken               = "TMP_TOKEN"
    case counterUserAccessApp   = "COUNTER_USER_ACCESS_APP"
    case counterRequestPermission
    case isFirstPermission
    case isFreeAds
    case access_token
    case preferences_key
    case user
    case device_id
}
