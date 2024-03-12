//
//  ContentChat.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 11/03/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import Foundation
import UIKit
import MessageKit

enum ContentChat: Codable {
    case text(value: String)
    case image(url: String)
    case audio(url: String)

    enum CodingKeys: String, CodingKey {
        case type
        case text
        case url_image
        case url_audio
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)

        switch type {
        case "text":
            let text = try container.decode(String.self, forKey: .text)
            self = .text(value: text)
        case "image":
            let url = try container.decode(String.self, forKey: .url_image)
            self = .image(url: url)
        case "audio":
            let url = try container.decode(String.self, forKey: .url_audio)
            self = .audio(url: url)
        default:
            throw DecodingError.dataCorruptedError(forKey: .type, in: container, debugDescription: "Unknown content type: \(type)")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .text(let text):
            try container.encode("text", forKey: .type)
            try container.encode(text, forKey: .text)
        case .image(let url):
            try container.encode("image", forKey: .type)
            try container.encode(url, forKey: .url_image)
        case .audio(let url):
            try container.encode("audio", forKey: .type)
            try container.encode(url, forKey: .url_audio)
        }
    }
}

struct ChatSender: SenderType {
    var senderId: String
    var displayName: String
    var avatar: String
    
    init(senderId: String, displayName: String, avatar: String) {
        self.senderId = senderId
        self.displayName = displayName
        self.avatar = avatar
    }
    
    init() {
        let user = UDHelpers.shared.getObject(type: User.self, forKey: .user)
        self.senderId = user?.user_id ?? "dummy"
        self.displayName = user?.name ?? "dummy"
        self.avatar = user?.avatar ?? "dummy"
    }
}

struct ChatMessage: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
    
    init(sender: SenderType, messageId: String, sentDate: Date, kind: MessageKind) {
        self.sender = sender
        self.messageId = messageId
        self.sentDate = sentDate
        self.kind = kind
    }
    
    init(kind: MessageKind) {
        self.sender = ChatSender()
        self.messageId = UUID().uuidString
        self.sentDate = Date()
        self.kind = kind
    }
}

struct MediaMessage: MediaItem {
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
}
