//
//  Chat+MessagesDataSource.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 02/09/19.
//  Copyright © 2019 Rangga Leo. All rights reserved.
//

import Foundation
import MessageKit

extension ChatViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        return Sender(senderId: RepoMemory.device_id, displayName: RepoMemory.user_name ?? "user_name")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
}
