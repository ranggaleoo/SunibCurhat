//
//  ChatsModel.swift
//  SunibCurhat
//
//  Created by Koinworks on 8/28/19.
//  Copyright © 2019 Rangga Leo. All rights reserved.
//

import Foundation

protocol DatabaseRepresentation {
    var representation: [String: Any] { get }
}

struct Chat {
    let id          : String?
    let chat_id     : String
    let users       : [String]
    let name        : String
    let date_create : Date
    
    init(name: String, chat_id: String, users: [String]) {
        self.id             = nil
        self.chat_id        = chat_id
        self.users          = users
        self.name           = name
        self.date_create    = Date()
    }
}

extension Chat: DatabaseRepresentation {
    var representation: [String : Any] {
        var rep: [String : Any] = [
            "chat_id"       : chat_id,
            "users"         : users,
            "name"          : name,
            "date_create"   : date_create
        ]
        
        if let id = id {
            rep["id"] = id
        }
        
        return rep
    }
    
}

extension Chat: Comparable {
    
    static func == (lhs: Chat, rhs: Chat) -> Bool {
        return lhs.chat_id == rhs.chat_id
    }
    
    static func < (lhs: Chat, rhs: Chat) -> Bool {
        return rhs.date_create < lhs.date_create
    }
    
}
