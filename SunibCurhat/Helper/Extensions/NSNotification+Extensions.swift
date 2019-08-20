//
//  NSNotification+Extensions.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 20/08/19.
//  Copyright © 2019 Rangga Leo. All rights reserved.
//

import Foundation

extension NSNotification.Name {
    static let tokenIsChanged = NSNotification.Name(rawValue: Bundle.main.bundleIdentifier! + ".tokenIsChanged")
}
