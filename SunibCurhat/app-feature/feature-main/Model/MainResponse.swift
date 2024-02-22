//
//  HTTPGenericResponse.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 17/08/19.
//  Copyright © 2019 Rangga Leo. All rights reserved.
//

import Foundation

struct MainResponse<T: Decodable>: Decodable {
    var success : Bool
    var data   : T?
    var message: String
    
    enum Keys: String, CodingKey {
        case success
        case data
        case message
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        self.success   = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        self.data     = try container.decodeIfPresent(T.self, forKey: .data)
        self.message  = try container.decodeIfPresent(String.self, forKey: .message) ?? "message unknown"
    }
}

struct EndpointResponse: Codable {
    let endpoint: String
}

struct RefreshTokenData: Codable {
    let access_token: String
}

struct Preferences: Codable {
    let app_name:                   String
    let version:                    String
    let url_update_version:         String
    let version_ios:                String
    let version_android:            String
    let url_update_version_ios:     String
    let url_update_version_android: String
    let contact_email:              String
    let contact_whatsapp:           String
    let contact_instagram:          String
    let reply_emojis:               [String]
    let report_reasons:             [String]
    let images:                     PreferenceImages
    let urls:                       PreferenceUrls
}

struct PreferenceImages: Codable {
    let image_url_login: String
    let image_url_register: String
}

struct  PreferenceUrls: Codable {
    let privacy_policy: String
    let user_agreement: String
}

struct User: Codable {
    let user_id:    String
    let device_id:  String
    let email:      String?
    let name:       String
    let avatar:     String
}
