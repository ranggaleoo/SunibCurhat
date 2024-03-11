//
//  ChatMessageView.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 11/03/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import UIKit
import Foundation
import MessageKit

class ChatMessageView: MessagesViewController {
    
    var conversation: Conversation? {
        didSet {
            updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func set(conversation: Conversation?) {
        self.conversation = conversation
    }
    
    func setupViews() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
    }
    
    private func updateUI() {
        title = conversation?.them().first?.name
        messagesCollectionView.reloadData()
    }
}
