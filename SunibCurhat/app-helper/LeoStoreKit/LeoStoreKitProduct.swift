//
//  LeoStoreKitProduct.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 01/12/20.
//  Copyright © 2020 Rangga Leo. All rights reserved.
//

import Foundation
import StoreKit

struct LeoStoreKitProduct {
    let id: Identifier
    let price: String
    let title: String
    let desc: String
    let item: SKProduct
    
    public enum Identifier: String, CaseIterable {
        case removeads
    }
}

extension LeoStoreKitProduct.Identifier {
    func get() -> String {
        return Bundle.main.bundleIdentifier ?? "" + "." + self.rawValue
    }
}
