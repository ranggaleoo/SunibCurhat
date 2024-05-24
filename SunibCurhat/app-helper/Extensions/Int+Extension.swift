//
//  Int+Extension.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 15/05/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import Foundation

extension Int {
    func unixTimestampMillisecondsToDate() -> Date {
        return Date(timeIntervalSince1970: TimeInterval(self) / 1000)
    }
}
