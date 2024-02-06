//
//  ChatModel.swift
//  SunibCurhat
//
//  Created by Koinworks on 8/29/19.
//  Copyright © 2019 Rangga Leo. All rights reserved.
//

import MessageKit

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
        let pushIsOn = ConstGlobal.setting_list.get(.pushNotification)?.usersValue ?? false
        self.id             = nil
        self.text_message   = text_message
        self.sender         = Sender(senderId: RepoMemory.device_id, displayName: RepoMemory.user_name ?? "user_name")
        self.sentDate       = Date()
        self.token_fcm      = pushIsOn ? RepoMemory.token_notif : nil
    }
    
    init(image: UIImage) {
        let pushIsOn = ConstGlobal.setting_list.get(.pushNotification)?.usersValue ?? false
        self.id             = nil
        self.image          = image
        self.text_message   = ""
        self.sender         = Sender(senderId: RepoMemory.device_id, displayName: RepoMemory.user_name ?? "user_name")
        self.sentDate       = Date()
        self.token_fcm      = pushIsOn ? RepoMemory.token_notif : nil
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
