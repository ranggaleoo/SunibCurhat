//
//  Logger.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 04/08/19.
//  Copyright © 2019 Rangga Leo. All rights reserved.
//

import Foundation

func print_r(title: String, message: Any?) {
    print("=====[START \(title.uppercased())]=====")
    print(message ?? "nothing")
    print("=====[END OF \(title.uppercased())=====]")
}

func checkRange(_ range: NSRange, contain index: Int) -> Bool {
    return index > range.location && index < range.location + range.length
}
