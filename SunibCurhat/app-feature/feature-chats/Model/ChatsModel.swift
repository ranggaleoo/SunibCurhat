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
    var users               : [User]
    var chats               : [Chat]
    var last_chat           : String?
    var last_chat_timestamp : Int?
    var blocked_by          : String?
}

extension Conversation: Equatable {
    static func == (lhs: Conversation, rhs: Conversation) -> Bool {
        return lhs.conversation_id == rhs.conversation_id
    }
}

extension Conversation {
    var isBlocked: Bool {
        return blocked_by != nil
    }
    
    var isBlockedByMe: Bool {
        if !isBlocked {
            return false
        }
        
        guard let me = me()?.user_id,
              let blocked_by_me = blocked_by
        else { return false }
        
        return me == blocked_by_me
    }
    
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
