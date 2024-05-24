// 
//  ChatsInteractor.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 24/02/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import Foundation

class ChatsInteractor: ChatsPresenterToInteractor {
    weak var presenter: ChatsInteractorToPresenter?
    
    func getConversations(request: RequestConversations) {
        SocketService.shared.emit(.req_conversations, request) { [weak self] result in
            switch result {
            case .success(let _):
                debugLog("success send request conversations")
            case .failure(let error):
                self?.presenter?.failRequestConversations(message: error.localizedDescription)
            }
        }
    }
}
