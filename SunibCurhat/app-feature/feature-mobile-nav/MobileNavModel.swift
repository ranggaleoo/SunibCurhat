//
//  MobileNavModel.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 05/03/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import Foundation
import UIKit

struct MobileNavigationPage: Codable {
    let id: String?
    let title: String?
    let sections: [MobileNavigationPageSection]?
}

struct MobileNavigationPageSection: Codable {
    let id: String?
    let title: String?
    let type: MobileNavigationType?
    let items: [MobileNavigationPageItem]?
}

struct MobileNavigationPageItem: Codable {
    let id: String?
    let title: String?
    let type: MobileNavigationType?
    let description: String?
    var content: MobileNavigationContent?
    let after_action: MobileNavigationAfterAction?
}

enum MobileNavigationType: String, Codable {
    case avatar
    case list
    case sub_menu
    case open_url
    case web_view
    case action_api
    case action_toggle
    case unknown
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        if let type = MobileNavigationType(rawValue: rawValue) {
            self = type
        } else {
            self = .unknown
        }
    }
}

enum MobileNavigationContent: Codable {
    case string(value: String)
    case url(value: URL)
    case bool(value: Bool)
    case sections(value: [MobileNavigationPageSection])
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let stringContent = try? container.decode(String.self) {
            if let urlString = URL(string: stringContent), UIApplication.shared.canOpenURL(urlString) {
                self = .url(value: urlString)
                return
            } else {
                self = .string(value: stringContent)
                return
            }
        }
        if let urlContent = try? container.decode(URL.self) {
            self = .url(value: urlContent)
            return
        }
        if let boolContent = try? container.decode(Bool.self) {
            self = .bool(value: boolContent)
            return
        }
        if let arrayContent = try? container.decode([MobileNavigationPageSection].self) {
            self = .sections(value: arrayContent)
            return
        }
        throw DecodingError.typeMismatch(MobileNavigationContent.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unsupported type for Content"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let stringValue):
            try container.encode(stringValue)
        case .url(let urlValue):
            try container.encode(urlValue)
        case .bool(value: let boolValue):
            try container.encode(boolValue)
        case .sections(let arrayValue):
            try container.encode(arrayValue)
        }
    }
}

enum MobileNavigationAfterAction: String, Codable {
    case delete_account
    case sign_out
    case push_notif
    case auto_clear_chat
    case unknown
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        if let action = MobileNavigationAfterAction(rawValue: rawValue) {
            self = action
        } else {
            self = .unknown
        }
    }
    
    func run(_ item: MobileNavigationPageItem? = nil, _ completion: ((Bool) -> Void)? = nil) {
        switch self {
        case .sign_out:
            UDHelpers.shared.remove(key: .user)
            UDHelpers.shared.remove(key: .access_token)
            UDHelpers.shared.remove(key: .refresh_token)
            completion?(true)
        case .delete_account:
            UDHelpers.shared.remove(key: .user)
            UDHelpers.shared.remove(key: .access_token)
            UDHelpers.shared.remove(key: .refresh_token)
            UDHelpers.shared.remove(key: .device_id)
            completion?(true)
        case .push_notif, .auto_clear_chat:
            if let item = item, item.type == .action_toggle, let itemID = item.id {
                switch item.content {
                case .bool(value: let value):
                    UDHelpers.shared.set(value: value, keyString: itemID)
                    completion?(true)
                default:
                    completion?(false)
                }
            }
        default:
            completion?(false)
        }
    }
}
