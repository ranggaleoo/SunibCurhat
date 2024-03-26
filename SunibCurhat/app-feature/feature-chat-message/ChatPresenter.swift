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
    private var isLoadChats: Bool = false
    private var page: Int? = 1
    private var item_per_page: Int = 15
    
    func didLoad() {
        SocketService.shared.delegate = self
        let name = conversation?.them().first?.name
        view?.setupViews(name: name)
        view?.reloadCollectionView()
    }
    
    func didScroll() {
        if let num_page = self.page,
           let convo = conversation,
           !isLoadChats {
            let shouldNumPage = num_page == 1 && convo.chats.count > 0 ? 2 : num_page
            
            isLoadChats = true
            interactor?.getChats(request: RequestChats(
                conversation_id: convo.conversation_id,
                page: shouldNumPage,
                item_per_page: item_per_page)
            )
        }
    }
    
    func didPop(to: ChatsPresenterToView) {
        router?.navigateToChats(to: to, conversation: conversation)
    }
    
    func set(conversation: Conversation?) {
        if var convo = conversation {
            convo.chats.sort { $0.created_at < $1.created_at }
            self.conversation = convo
        }
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
    func didGetChats(response: ResponseChats) {
        for chat in response.chats {
            if let chats = conversation?.chats,
               !chats.contains(chat) {
                conversation?.chats.insert(chat, at: 0)
            }
        }
        isLoadChats = false
        page = response.next_page
        view?.reloadAndKeepOffset()
    }
    
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
