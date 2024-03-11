//
//  ChatMessageView + MessagesDataSource.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 11/03/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import Foundation
import UIKit
import MessageKit

extension ChatMessageView: MessagesDataSource {
    func currentSender() -> SenderType {
        if let sender = conversation?.me()?.sender() {
            return sender
        }
        return ChatSender(senderId: "dummy", displayName: "dummty", avatar: "dummy")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        if let message = conversation?.chats.item(at: indexPath.row)?.message() {
            return message
        }
        
        let chatSender = ChatSender(senderId: "dummy", displayName: "dummy", avatar: "dummy")
        let chatMessage = ChatMessage(sender: chatSender, messageId: "dummy", sentDate: Date(), kind: .text("Hello World"))
        
        return chatMessage
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return 1
    }
}
