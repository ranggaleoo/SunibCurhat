//
//  ChatsModel.swift
//  SunibCurhat
//
//  Created by Koinworks on 8/28/19.
//  Copyright © 2019 Rangga Leo. All rights reserved.
//

import Foundation

struct Conversation: Codable {
    let conversation_id     : String
    let users               : [User]
    let chats               : [Chat]
    let last_chat           : String?
    let last_chat_timestamp : Date?
}


extension Conversation {
    func me() -> User? {
        if let me = UDHelpers.shared.getObject(type: User.self, forKey: .user),
           users.count > 0 {
            
            return users.first { (user) in
                user.user_id == me.user_id
            }
        }
        return nil
    }
    
    func them() -> [User] {
        if let me = UDHelpers.shared.getObject(type: User.self, forKey: .user),
           users.count > 0 {
            return users.filter({ return me.user_id != $0.user_id })
        }
        return []
    }
}
