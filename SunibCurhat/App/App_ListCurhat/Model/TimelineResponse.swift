//
//  TimelineResponse.swift
//  SunibCurhat
//
//  Created by Koinworks on 8/21/19.
//  Copyright © 2019 Rangga Leo. All rights reserved.
//

import Foundation

struct TimelineResponse: Decodable {
    var timeline_id : String
    var device_id   : String
    var name        : String
    var text_content: String
    var timed       : String
    
    enum Keys: String, CodingKey {
        case timeline_id
        case device_id
        case name
        case text_content
        case timed
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        self.timeline_id    = try container.decodeIfPresent(String.self, forKey: .timeline_id) ?? ""
        self.device_id      = try container.decodeIfPresent(String.self, forKey: .device_id) ?? ""
        self.name           = try container.decodeIfPresent(String.self, forKey: .name) ?? "Sunib Curhat"
        self.text_content   = try container.decodeIfPresent(String.self, forKey: .text_content) ?? "Content"
        self.timed          = try container.decodeIfPresent(String.self, forKey: .timed) ?? ""
    }
}
