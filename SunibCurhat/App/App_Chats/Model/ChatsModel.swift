//
//  ChatsModel.swift
//  SunibCurhat
//
//  Created by Koinworks on 8/28/19.
//  Copyright © 2019 Rangga Leo. All rights reserved.
//

import Foundation
import FirebaseFirestore

protocol DatabaseRepresentation {
    var representation: [String: Any] { get }
}

struct Chat {
    let id      : String?
    let chat_id : String
    let name    : String
    
    init(name: String, chat_id: String) {
        id = nil
        self.chat_id    = chat_id
        self.name       = name
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        
        guard
            let chat_id = data["chat_id"] as? String,
            let name    = data["name"] as? String
        else {
            return nil
        }
        
        id = document.documentID
        self.chat_id = chat_id
        self.name = name
    }
}

extension Chat: DatabaseRepresentation {
    var representation: [String : Any] {
        var rep = [
            "chat_id"   : chat_id,
            "name"      : name
        ]
        
        if let id = id {
            rep["id"] = id
        }
        
        return rep
    }
    
}

extension Chat: Comparable {
    
    static func == (lhs: Chat, rhs: Chat) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func < (lhs: Chat, rhs: Chat) -> Bool {
        return lhs.chat_id < rhs.chat_id
    }
    
}
