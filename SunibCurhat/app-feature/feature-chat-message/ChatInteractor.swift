// 
//  ChatInteractor.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 11/03/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import Foundation

class ChatInteractor: ChatPresenterToInteractor {
    weak var presenter: ChatInteractorToPresenter?
    
    func getChats(request: RequestChats) {
        SocketService.shared.emit(.req_chats, request) { [weak self] (result) in
            switch result {
            case .success():
                debugLog("success send request chats")
            case .failure(let err):
                debugLog(err.localizedDescription)
            }
        }
    }
    
    func sendChat(chat: Chat) {
        SocketService.shared.emit(.req_send_chat, chat) { [weak self] (result) in
            switch result {
            case .success():
                self?.presenter?.didSendChat()
            case .failure(let err):
                self?.presenter?.failSendChat(message: err.localizedDescription)
            }
        }
    }
    
    func typing(chat: Chat) {
        SocketService.shared.emit(.req_typing, chat) { [weak self] (result) in
            switch result {
            case .success():
                break
            case .failure(let err):
                debugLog(err.localizedDescription)
                break
            }
        }
    }
}
