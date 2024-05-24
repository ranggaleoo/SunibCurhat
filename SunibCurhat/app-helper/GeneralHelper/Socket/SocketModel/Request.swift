//
//  Request.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 12/03/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import Foundation

struct RequestConversations: Codable {
    let user_id: String
    let page: Int
    let item_per_page: Int
}

struct RequestChats: Codable {
    let conversation_id: String
    let page: Int
    let item_per_page: Int
}
