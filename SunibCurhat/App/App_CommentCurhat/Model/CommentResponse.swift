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
    var comment_id  : String
    var timeline_id : String
    var device_id   : String
    var name        : String
    var text_content: String
    var timed       : String
    
    enum Keys: String, CodingKey {
        case comment_id
        case timeline_id
        case device_id
        case name
        case text_content
        case timed
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        self.comment_id     = try container.decodeIfPresent(String.self, forKey: .comment_id) ?? ""
        self.timeline_id    = try container.decodeIfPresent(String.self, forKey: .timeline_id) ?? ""
        self.device_id      = try container.decodeIfPresent(String.self, forKey: .device_id) ?? ""
        self.name           = try container.decodeIfPresent(String.self, forKey: .name) ?? "user_name"
        self.text_content   = try container.decodeIfPresent(String.self, forKey: .text_content) ?? "Content"
        self.timed          = try container.decodeIfPresent(String.self, forKey: .timed) ?? ""
    }
}
