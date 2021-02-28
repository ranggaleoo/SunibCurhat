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
