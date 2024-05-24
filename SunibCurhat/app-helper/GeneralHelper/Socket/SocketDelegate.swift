//
//  SocketDelegate.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 12/05/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import Foundation


protocol SocketDelegate: AnyObject {
    func didUserOnline(user: User)
    func didUserOffline(user: User)
    
    func didGetConversations(response: ResponseConversations)
    func failGetConversations(message: String)
    
    func didReceiveChat(chat: Chat)
    func failGetChats(message: String)
    
    func didUserTyping(chat: Chat)
    
    func didMarkChatsRead(chats: [Chat])
    
    func didGetChats(response: ResponseChats)
    
    func didUpdateBlockUser(conversation: Conversation)
    func failUpdateBlock(message: String)
}

// default implementation
extension SocketDelegate {
    func didUserOnline(user: User) { }
    func didUserOffline(user: User) { }
    
    func didGetConversations(response: ResponseConversations) { }
    func failGetConversations(message: String) { }
    
    func didReceiveChat(chat: Chat) { }
    func failGetChats(message: String) { }
    
    func didUserTyping(chat: Chat) { }
    
    func didMarkChatsRead(chats: [Chat]) { }
    
    func didGetChats(response: ResponseChats) { }
    
    func didUpdateBlockUser(conversation: Conversation) { }
    func failUpdateBlock(message: String) { }
}
