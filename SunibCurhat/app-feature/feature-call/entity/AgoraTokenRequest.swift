//
//  AgoraTokenRequest.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 04/07/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import Foundation

struct AgoraTokenRequest: Codable {
    enum TokenType: String, Codable {
        case rtc, rtm, chat
    }
    let tokenType: TokenType
    let channel: String
    let uid: String
    let role: Call.Role?
    let expire: Int?
}
