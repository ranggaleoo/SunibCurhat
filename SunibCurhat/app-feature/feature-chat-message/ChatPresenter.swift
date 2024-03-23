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
    private var is_typing: Bool = false
    
    func didLoad() {
        SocketService.shared.delegate = self
        let name = conversation?.them().first?.name
        view?.setupViews(name: name)
        view?.reloadCollectionView()
    }
    
    func set(conversation: Conversation?) {
        self.conversation = conversation
    }
    
    func typingIsStopped() {
        is_typing = false
    }
    
    func didPressSendButtonWith(text: String) {
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty,
              let conversation_id = conversation?.conversation_id,
              let from = conversation?.me(),
              let to = conversation?.them().first
        else { return }
        
        let chat = Chat(
            chat_id: UUID().uuidString,
            conversation_id: conversation_id,
            from: from,
            to: to,
            content: .text(value: text),
            is_typing: false,
            is_read: false,
            created_at: Date()
        )
        
        interactor?.sendChat(chat: chat)
    }
    
    func textViewTextDidChangeTo(text: String) {
        debugLog(text)
        //is typing
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty,
              !is_typing,
              let conversation_id = conversation?.conversation_id,
              let from = conversation?.me(),
              let to = conversation?.them().first
        else { return }
        
        is_typing = true
        debugLog(is_typing)
        
        let chat = Chat(
            chat_id: UUID().uuidString,
            conversation_id: conversation_id,
            from: from,
            to: to,
            content: .text(value: text),
            is_typing: true,
            is_read: false,
            created_at: Date()
        )
        
        interactor?.typing(chat: chat)
    }
    
    func getSender() -> SenderType? {
        return conversation?.me()?.sender()
    }
    
    func isFromCurrentSender(message: MessageType) -> Bool {
        return message.sender.senderId == (conversation?.me()?.sender().senderId ?? "")
    }
    
    func messageForItem(at indexPath: IndexPath) -> MessageType? {
        return conversation?.chats.item(at: indexPath.row)?.message()
    }
    
    func numberOfSections() -> Int? {
        return 1
    }
    
    func numberOfItems(inSection section: Int) -> Int? {
        return conversation?.chats.count
    }
}

extension ChatPresenter: ChatInteractorToPresenter {
    func didSendChat() {
        //
    }
    
    func failSendChat(message: String) {
        view?.showAlert(title: "Oops", message: message)
    }
}

extension ChatPresenter: SocketDelegate {
    func didUserTyping(chat: Chat) {
        if let typing = chat.is_typing, typing && is_typing {
            view?.showTyping(chat: chat)
        }
    }
    
    func didReceiveChat(chat: Chat) {
        conversation?.chats.append(chat)
        view?.reloadCollectionView()
    }
    
    func failGetChats(message: String) {
        view?.showAlert(title: "Oops", message: message)
    }
}
