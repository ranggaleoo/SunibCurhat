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
    private var page: Int = 0
    private var item_per_page: Int = 3
    
    func didLoad() {
        SocketService.shared.delegate = self
        view?.setupViews()
        interactor?.getConversations(request: RequestConversations(
            user_id: user?.user_id ?? "",
            page: self.page,
            item_per_page: self.item_per_page
        ))
    }
    
    func numberOfRowsInSection() -> Int {
        return conversations.count
    }
    
    func cellForRowAt(indexPath: IndexPath) -> Conversation {
        return conversations[indexPath.row]
    }
    
    func createConversation(conversation: Conversation) {
        if !conversations.contains(conversation) {
            conversations.append(conversation)
            let indexPaths = [IndexPath(row: conversations.count - 1, section: 0)]
            view?.insertRow(at: indexPaths)
        }
        router?.navigateToChat(from: view, conversation: conversation)
    }
}

extension ChatsPresenter: ChatsInteractorToPresenter {
    func failRequestConversations(message: String) {
        view?.showAlertMessage(title: "Oops", message: message)
    }
}

extension ChatsPresenter: SocketDelegate {
    func didGetConversations(response: ResponseConversations) {
        var countConversation = conversations.count
        var indexPaths: [IndexPath] = []
        for conversation in response.conversations {
            indexPaths.append(IndexPath(row: countConversation, section: 0))
            countConversation += 1
        }
        
        conversations.append(response.conversations)
        page = response.next_page
        view?.insertRow(at: indexPaths)
    }
    
    func failGetConversations(message: String) {
        view?.showAlertMessage(title: "Oops", message: message)
    }
}
