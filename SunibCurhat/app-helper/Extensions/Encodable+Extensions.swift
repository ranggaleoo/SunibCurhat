//
//  Encodable+Extensions.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 12/06/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import Foundation
extension Encodable {
    func toDictionary() -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(self),
              let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
              let dictionary = jsonObject as? [String: Any] else {
            return nil
        }
        return dictionary
    }
}
