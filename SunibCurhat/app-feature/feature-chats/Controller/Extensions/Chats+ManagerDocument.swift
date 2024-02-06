//
//  Chats+ManagerDocument.swift
//  SunibCurhat
//
//  Created by Koinworks on 8/28/19.
//  Copyright © 2019 Rangga Leo. All rights reserved.
//

import Foundation
import UIKit

extension ChatsViewController {    
    private func addChannelToTable(_ chat: Chat) {
        guard !chats.contains(chat) else {
            return
        }
        
        chats.append(chat)
        chats.sort()
        
        guard let index = chats.firstIndex(of: chat) else {
            return
        }
        tableViewChats.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    private func updateChannelInTable(_ chat: Chat) {
        guard let index = chats.firstIndex(of: chat) else {
            return
        }
        
        chats[index] = chat
        tableViewChats.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    private func removeChannelFromTable(_ chat: Chat) {
        guard let index = chats.firstIndex(of: chat) else {
            return
        }
        
        chats.remove(at: index)
        tableViewChats.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
}
