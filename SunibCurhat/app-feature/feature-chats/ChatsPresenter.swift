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
    
    func didLoad() {
        view?.setupViews()
        SocketService.shared.delegate = self
    }
    
    func numberOfRowsInSection() -> Int {
        return conversations.count
    }
    
    func cellForRowAt(indexPath: IndexPath) -> Conversation {
        return conversations[indexPath.row]
    }
    
    func createConversation(conversation: Conversation) {
        conversations.append(conversation)
        let indexPaths = [IndexPath(row: conversations.count - 1, section: 0)]
        view?.insertRow(at: indexPaths)
    }
}

extension ChatsPresenter: ChatsInteractorToPresenter {
}

extension ChatsPresenter: SocketDelegate {    

}
