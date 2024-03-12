//
//  ChatPresenter.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 11/03/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import Foundation
import MessageKit

class ChatPresenter: ChatViewToPresenter {
    weak var view: ChatPresenterToView?
    var interactor: ChatPresenterToInteractor?
    var router: ChatPresenterToRouter?
    
    private var conversation: Conversation?
    
    func didLoad() {
        let name = conversation?.them().first?.name
        view?.setupViews(name: name)
        view?.reloadCollectionView()
    }
    
    func set(conversation: Conversation?) {
        self.conversation = conversation
    }
    
    func getSender() -> SenderType? {
        return conversation?.me()?.sender()
    }
    
    func isFromCurrentSender(message: MessageType) -> Bool {
        return message.sender.senderId == (conversation?.me()?.sender().senderId ?? "")
    }
    
    func messageForItem(at indexPath: IndexPath) -> MessageType? {
        return conversation?.chats[indexPath.row].message()
    }
    
    func numberOfSections() -> Int? {
        return 1
    }
    
    func numberOfItems(inSection section: Int) -> Int? {
        return conversation?.chats.count
    }
}

extension ChatPresenter: ChatInteractorToPresenter {
}
