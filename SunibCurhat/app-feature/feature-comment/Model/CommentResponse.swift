//
//  CommentResponse.swift
//  SunibCurhat
//
//  Created by Koinworks on 8/22/19.
//  Copyright © 2019 Rangga Leo. All rights reserved.
//

import Foundation

struct CommentResponse: Decodable {
    var page: Int
    var next_page: Int
    var comments: [CommentItems]
}

struct CommentItems: Decodable {
    var comment_id  : Int
    var timeline_id : Int
    var user_id     : String
    
    @available(*, deprecated, renamed: "user_id", message: "use user_id instead")
    var device_id   : String
    var name        : String
    var text_content: String
    var avatar      : String
    
    @available(*, deprecated, renamed: "created_at", message: "use created_at instead")
    var timed       : String
    var created_at  : String
    var updated_at  : String
    
    enum Keys: String, CodingKey {
        case comment_id
        case timeline_id
        case user_id
        case device_id
        case name
        case text_content
        case avatar
        case timed
        case created_at
        case updated_at
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        self.comment_id     = try container.decodeIfPresent(Int.self, forKey: .comment_id) ?? 0
        self.timeline_id    = try container.decodeIfPresent(Int.self, forKey: .timeline_id) ?? 0
        self.user_id        = try container.decodeIfPresent(String.self, forKey: .user_id) ?? ""
        self.device_id      = try container.decodeIfPresent(String.self, forKey: .device_id) ?? ""
        self.name           = try container.decodeIfPresent(String.self, forKey: .name) ?? "user_name"
        self.text_content   = try container.decodeIfPresent(String.self, forKey: .text_content) ?? "Content"
        self.avatar         = try container.decodeIfPresent(String.self, forKey: .avatar) ?? ""
        self.timed          = try container.decodeIfPresent(String.self, forKey: .timed) ?? ""
        self.created_at     = try container.decodeIfPresent(String.self, forKey: .created_at) ?? ""
        self.updated_at     = try container.decodeIfPresent(String.self, forKey: .updated_at) ?? ""
    }
}
