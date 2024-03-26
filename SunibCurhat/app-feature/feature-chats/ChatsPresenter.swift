//
//  ChatsPresenter.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 24/02/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import Foundation

class ChatsPresenter: ChatsViewToPresenter {
    weak var view: ChatsPresenterToView?
    var interactor: ChatsPresenterToInteractor?
    var router: ChatsPresenterToRouter?
    
    private var conversations: [Conversation] = []
    private var user: User? = UDHelpers.shared.getObject(type: User.self, forKey: .user)
    private var isLoadConversation: Bool = false
    private var isRefresh: Bool = false
    private var page: Int? = 1
    private var item_per_page: Int = 10
    
    func didLoad() {
        SocketService.shared.delegate = self
        view?.setupViews()
    }
    
    func didScroll() {
        if let num_page = self.page, !isLoadConversation {
            isLoadConversation = true
            interactor?.getConversations(request: RequestConversations(
                user_id: user?.user_id ?? "",
                page: num_page,
                item_per_page: self.item_per_page
            ))
        }
    }
    
    
    func didRefresh() {
        if !isLoadConversation {
            isRefresh = true
            isLoadConversation = true
            page = 1
            conversations.removeAll()
            interactor?.getConversations(request: RequestConversations(
                user_id: user?.user_id ?? "",
                page: self.page ?? 1,
                item_per_page: self.item_per_page
            ))
        }
    }
    
    func numberOfRowsInSection() -> Int {
        return conversations.count
    }
    
    func cellForRowAt(indexPath: IndexPath) -> Conversation? {
        return conversations.item(at: indexPath.row)
    }
    
    func didSelectRowAt(indexPath: IndexPath) {
        let conversation = conversations.item(at: indexPath.row)
        router?.navigateToChat(from: view, conversation: conversation)
    }
    
    func createConversation(conversation: Conversation) {
        if !conversations.contains(conversation) {
            conversations.insert(conversation, at: 0)
            let indexPaths = [IndexPath(row: 0, section: 0)]
            view?.insertRow(at: indexPaths)
        }
        router?.navigateToChat(from: view, conversation: conversation)
    }
    
    func syncConversation(conversation: Conversation?) {
        if let convo = conversation,
           let index = conversations.firstIndex(of: convo),
           let lastChatItem = convo.chats.last {
            conversations[index].chats = convo.chats
            conversations[index].last_chat_timestamp = lastChatItem.created_at
            
            switch lastChatItem.content {
            case .text(let value):
                conversations[index].last_chat = value
            case .image( _):
                conversations[index].last_chat = "[image]"
            case .audio( _):
                conversations[index].last_chat = "[audio]"
            case .none:
                conversations[index].last_chat = "Chat Aku Dong!"
            }
            
            view?.reloadRow(at: [IndexPath(row: index, section: 0)])
        }
    }
}

extension ChatsPresenter: ChatsInteractorToPresenter {
    func failRequestConversations(message: String) {
        isRefresh = false
        isLoadConversation = false
        view?.dismissRefreshControl()
        view?.showAlertMessage(title: "Oops", message: message)
    }
}

extension ChatsPresenter: SocketDelegate {
    func didGetConversations(response: ResponseConversations) {
        var countConversation = conversations.count
        var indexPaths: [IndexPath] = []
        
        for conversation in response.conversations {
            if(!conversations.contains(conversation)) {
                conversations.append(conversation)
                indexPaths.append(IndexPath(row: countConversation, section: 0))
                countConversation += 1
            }
        }
        isLoadConversation = false
        page = response.next_page
        
        if isRefresh {
            view?.dismissRefreshControl()
            view?.reloadData()
            isRefresh = false
        } else {
            view?.insertRow(at: indexPaths)
        }
    }
    
    func failGetConversations(message: String) {
        isRefresh = false
        isLoadConversation = false
        view?.dismissRefreshControl()
        view?.showAlertMessage(title: "Oops", message: message)
    }
}
