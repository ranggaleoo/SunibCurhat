//
//  Call.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 08/07/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import Foundation

struct Call: Codable {
    enum Role: String, Codable {
        case publisher
        case subscriber
    }
    
    enum CallType: String, Codable {
        case video_call
        case voice_call
    }
    
    let call_id: String
    let conversation_id: String
    let from: User?
    let to: User?
    let role: Role
    let type: CallType
    var rtc_token: String?
    var rtm_token: String?
    let created_at: Int
}
