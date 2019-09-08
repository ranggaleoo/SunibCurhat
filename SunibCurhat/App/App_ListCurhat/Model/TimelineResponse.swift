//
//  TimelineResponse.swift
//  SunibCurhat
//
//  Created by Koinworks on 8/21/19.
//  Copyright © 2019 Rangga Leo. All rights reserved.
//

import Foundation

struct TimelineResponse: Decodable {
    var page        : Int
    var next_page   : Int
    var timelines   : [TimelineItems]
}

struct TimelineItems: Decodable {
    var timeline_id : Int
    var device_id   : String
    var name        : String
    var text_content: String
    var timed       : String
    
    var is_liked        : Bool
    var total_likes     : Int
    var total_comments  : Int
    var total_shares    : Int
    
    var is_ads          : Bool
    var ads_type        : String?
    var ad_unit_id      : String?
    var ad_url_media    : String?
    var ad_url_action   : String?
    
    enum Keys: String, CodingKey {
        case timeline_id
        case device_id
        case name
        case text_content
        case timed
        
        case is_liked
        case total_likes
        case total_comments
        case total_shares
        
        case is_ads
        case ads_type
        case ad_unit_id
        case ad_url_media
        case ad_url_action
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        self.timeline_id    = try container.decodeIfPresent(Int.self, forKey: .timeline_id) ?? 0
        self.device_id      = try container.decodeIfPresent(String.self, forKey: .device_id) ?? ""
        self.name           = try container.decodeIfPresent(String.self, forKey: .name) ?? "Sunib Curhat"
        self.text_content   = try container.decodeIfPresent(String.self, forKey: .text_content) ?? "Content"
        self.timed          = try container.decodeIfPresent(String.self, forKey: .timed) ?? ""
        
        self.is_liked       = try container.decodeIfPresent(Bool.self, forKey: .is_liked) ?? false
        self.total_likes    = try container.decodeIfPresent(Int.self, forKey: .total_likes) ?? 0
        self.total_comments = try container.decodeIfPresent(Int.self, forKey: .total_comments) ?? 0
        self.total_shares   = try container.decodeIfPresent(Int.self, forKey: .total_shares) ?? 0
        
        self.is_ads         = try container.decodeIfPresent(Bool.self, forKey: .is_ads) ?? false
        self.ads_type       = try container.decodeIfPresent(String.self, forKey: .ads_type) ?? ""
        self.ad_unit_id     = try container.decodeIfPresent(String.self, forKey: .ad_unit_id) ?? ""
        self.ad_url_media   = try container.decodeIfPresent(String.self, forKey: .ad_url_media) ?? ""
        self.ad_url_action  = try container.decodeIfPresent(String.self, forKey: .ad_url_action) ?? ""
    }
}

extension TimelineItems: Equatable {    
    static func == (lhs: TimelineItems, rhs: TimelineItems) -> Bool {
        return rhs.timeline_id == lhs.timeline_id
    }
}
