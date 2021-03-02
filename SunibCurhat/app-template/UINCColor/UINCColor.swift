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
    case blue = "008DDD"
    case gray_absolute = "8E8E93"
    case gray = "8E8E93"
    case black_absolute = "000000"
    case yellow = "F5D31E"
        
    func get() -> UIColor {
        return self.rawValue.hexToUIColor()
    }
    
    static func brandColor() -> UIColor {
        return UINCColor.blue.get()
    }
    
    static func secondBrandColor() -> UIColor {
        return UINCColor.blue_absolute.get()
    }
}
