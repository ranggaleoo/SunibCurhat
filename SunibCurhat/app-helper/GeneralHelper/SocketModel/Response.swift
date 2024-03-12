//
//  Response.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 12/03/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import Foundation

struct ResponseConversations: Codable {
    let page: Int
    let next_page: Int
    let conversations: [Conversation]
}
