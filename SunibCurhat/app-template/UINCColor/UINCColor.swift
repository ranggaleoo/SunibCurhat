//
//  UINCColor.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 02/03/21.
//  Copyright © 2021 Rangga Leo. All rights reserved.
//

import UIKit

// name color on https://chir.ag/projects/name-that-color/

enum UINCColor: String {
    case red_absolute = "CE0000"
    case blue_absolute = "006CEA"
    case blue = "0090E2"
    case gray_absolute = "8E8E93"
    case black_absolute = "000000"
    case yellow = "F5D31E"
    case primary_foreground_color = "FFFFFF"
    case secondary_foreground_color = "F5F5F5"
    case tertiary_foreground_color = "1C3340"
    case primary400 = "1DA6F3"
    case primary500 = "008DDD"
    case primary600 = "0076B9"
    case secondary400 = "5586A2"
    case secondary500 = "3D667E"
    case secondary600 = "2E4F61"
    case tertiary400 = "ECECEC"
    case tertiary500 = "DEDEDE"
    case tertiary600 = "CBCBCB"
    case info_color = "00D1ED"
    case success_color = "52C41A"
    case warning_color = "FAAD14"
    case error_color = "FF4D4F"
        
    func get() -> UIColor {
        return self.rawValue.hexToUIColor()
    }
    
    static func brandColor() -> UIColor {
        return UINCColor.blue.get()
    }
    
    static func secondBrandColor() -> UIColor {
        return UINCColor.blue_absolute.get()
    }
    
    static var primary: UIColor = {
        return UINCColor.primary500.get()
    }()
    
    static var secondary: UIColor = {
        return UINCColor.secondary500.get()
    }()
    
    static var tertiary: UIColor = {
        return UINCColor.tertiary500.get()
    }()
    
    static var primary_foreground: UIColor = {
        return UINCColor.primary_foreground_color.get()
    }()
    
    static var secondary_foreground: UIColor = {
        return UINCColor.secondary_foreground_color.get()
    }()
    
    static var tertiary_foreground: UIColor = {
        return UINCColor.tertiary_foreground_color.get()
    }()
    
    static var bg_primary: UIColor = {
        return UIColor.systemBackground
    }()
    
    static var bg_secondary: UIColor = {
        return UIColor.secondarySystemBackground
    }()
    
    static var bg_tertiary: UIColor = {
        return UIColor.tertiarySystemBackground
    }()
    
    static var info: UIColor = {
        return UINCColor.info_color.get()
    }()
    
    static var success: UIColor = {
        return UINCColor.success_color.get()
    }()
    
    static var warning: UIColor = {
        return UINCColor.warning_color.get()
    }()
    
    static var error: UIColor = {
        return UINCColor.error_color.get()
    }()
}
