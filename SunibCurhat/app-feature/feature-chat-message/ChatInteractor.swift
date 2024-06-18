// 
//  ChatInteractor.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 11/03/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import Foundation
import UIKit

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
                debugLog("success send chat")
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
    
    func uploadImage(image: UIImage) {
        if let imageData = image.jpegData(compressionQuality: 0.5) {
            CloudinaryService.shared.upload(data: imageData) { [weak self] (prog) in
                debugLog(prog.localizedDescription ?? "")
            } completion: { [weak self] (result, error) in
                if let res = result {
                    self?.presenter?.didUploadImage(response: res)
                }
                
                if let err = error {
                    debugLog(err)
                    self?.presenter?.failUploadImage(message: err.localizedDescription)
                }
            }

        }
    }
    
    func markAsRead(chats: [Chat]) {
        SocketService.shared.emit(.req_mark_chat_read, chats) { [weak self] (result) in
            switch result {
            case .success():
                debugLog("success request mark chat")
            case .failure(let err):
                debugLog(err.localizedDescription)
            }
        }
    }
    
    func updateBlock(conversation: Conversation) {
        SocketService.shared.emit(.req_update_block, conversation) { [weak self] (result) in
            switch result {
            case .success():
                debugLog("success send update block \(String(describing: conversation.conversation_id))")
            case .failure(let err):
                self?.presenter?.failUpdateBlockUser(message: err.localizedDescription)
            }
        }
    }
    
    func fetchToken(conversation: MediaConversation) {
        MainService.shared.fetchRtcToken(conversation: conversation) { [weak self] (result) in
            switch result {
            case .success(let res):
                if let token = res.data {
                    var mediaConversation = conversation
                    mediaConversation.token = token
                    self?.presenter?.didGetRtcToken(conversation: mediaConversation)
                } else {
                    debugLog(res.message)
                }
            case .failure(let err):
                debugLog(err.localizedDescription)
            }
        }
    }
}
