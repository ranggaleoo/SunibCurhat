//
//  Logger.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 04/08/19.
//  Copyright © 2019 Rangga Leo. All rights reserved.
//

import Foundation
import StoreKit

func print_r(title: String, message: Any?) {
    print("=====[START \(title.uppercased())]=====")
    print(message ?? "nothing")
    print("=====[END OF \(title.uppercased())=====]")
}

func debugLog(_ items: Any..., fileName: String = #file,
                     functionName: String = #function,
                     lineNumber: Int = #line,
                     separator: String = "\n",
                     terminator: String = "\n") {
//    #if DEBUG
    let file = fileName.components(separatedBy: "/").last ?? ""
    let prefix = "❌ File: \(file), Function: \(functionName), Line: \(lineNumber), Message: "
    let output = items.map { "\($0)" }.joined(separator: separator)
    Swift.print(prefix + output, terminator: terminator)
//    #else
//    #endif
}

func checkRange(_ range: NSRange, contain index: Int) -> Bool {
    return index > range.location && index < range.location + range.length
}
