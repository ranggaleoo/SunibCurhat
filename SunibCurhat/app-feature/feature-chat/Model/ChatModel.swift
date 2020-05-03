//
//  ChatModel.swift
//  SunibCurhat
//
//  Created by Koinworks on 8/29/19.
//  Copyright © 2019 Rangga Leo. All rights reserved.
//

import Firebase
import MessageKit
import FirebaseFirestore

extension UIImage: MediaItem {
    public var url: URL? { return nil }
    public var image: UIImage? { return self }
    public var placeholderImage: UIImage { return self }
}

struct Message: MessageType {
    
    let id              : String?
    let text_message    : String
    var image           : UIImage?  = nil
    var url_image       : URL?      = nil
    
    
    let sender          : SenderType
    var messageId       : String {
        return self.id ?? UUID().uuidString
    }
    let sentDate        : Date
    var kind            : MessageKind {
        if let img = self.image {
            return .photo(img)
        } else {
            return .text(text_message)
        }
    }
    
    var token_fcm       : String?
    
    init(text_message: String) {
        self.id             = nil
        self.text_message   = text_message
        self.sender         = Sender(senderId: RepoMemory.device_id, displayName: RepoMemory.user_name ?? "user_name")
        self.sentDate       = Date()
        self.token_fcm      = RepoMemory.token_notif ?? "token"
    }
    
    init(image: UIImage) {
        self.id             = nil
        self.image          = image
        self.text_message   = ""
        self.sender         = Sender(senderId: RepoMemory.device_id, displayName: RepoMemory.user_name ?? "user_name")
        self.sentDate       = Date()
        self.token_fcm      = RepoMemory.token_notif ?? "token"
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        
        guard let sentDate = data["date_create"] as? Timestamp else {
            return nil
        }
        guard let senderID = data["sender_id"] as? String else {
            return nil
        }
        guard let senderName = data["sender_name"] as? String else {
            return nil
        }
        guard let token_fcm = data["token_fcm"] as? String else {
            return nil
        }
        
        self.id         = document.documentID
        self.sentDate   = sentDate.dateValue()
        self.sender     = Sender(senderId: senderID, displayName: senderName)
        self.token_fcm  = token_fcm
        
        if let text = data["text_message"] as? String {
            self.text_message   = text
            self.url_image      = nil
        
        } else if let urlString = data["url_image"] as? String, let url_image = URL(string: urlString) {
            self.url_image      = url_image
            self.text_message   = ""
        
        } else {
            return nil
        }
    }
    
}

extension Message: DatabaseRepresentation {
    
    var representation: [String : Any] {
        var rep: [String : Any] = [
            "date_create"   : self.sentDate,
            "sender_id"     : self.sender.senderId,
            "sender_name"   : self.sender.displayName,
            "token_fcm"     : self.token_fcm ?? ""
        ]
        
        if let url = self.url_image {
            rep["url_image"]    = url.absoluteString
        } else {
            rep["text_message"] = self.text_message
        }
        
        return rep
    }
    
}

extension Message: Comparable {
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func < (lhs: Message, rhs: Message) -> Bool {
        return lhs.sentDate < rhs.sentDate
    }
}
