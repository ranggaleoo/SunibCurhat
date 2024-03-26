//
//  Chat.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 11/03/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import Foundation
import UIKit
import MessageKit

struct Chat: Codable {
    let chat_id: String
    let conversation_id: String
    let from: User?
    let to: User?
    let content: ContentChat?
    let is_typing: Bool?
    let is_read: Bool?
    let created_at: Date
}

extension Chat: Equatable {
    static func == (lhs: Chat, rhs: Chat) -> Bool {
        return lhs.chat_id == rhs.chat_id
    }
}

extension Chat {
    func sender() -> SenderType? {
        guard let sender = from else { return nil }
        
        return ChatSender(
            senderId: sender.user_id,
            displayName: sender.name,
            avatar: sender.avatar
        )
    }
    
    func message() -> MessageType? {
        guard let content = self.content else { return nil }
        guard let sender = self.sender() else { return nil }
        var message: MessageKind?
        
        switch content {
        case .text(value: let text):
            message = .text(text)
        case .image(url: let url_string):
            guard let url = URL(string: url_string),
                  let placeholderImage: UIImage = UIImage(identifierName: .image_super_thankyou)
            else { return nil }
            
            let media: MediaMessage = MediaMessage(
                url: url,
                placeholderImage: placeholderImage,
                size: CGSize(width: 50, height: 50)
            )
            message = .photo(media)
        default:
            return nil
        }
        
        guard let msg = message else { return nil }
        
        return ChatMessage(
            sender: sender,
            messageId: self.chat_id,
            sentDate: self.created_at,
            kind: msg
        )
    }
}
