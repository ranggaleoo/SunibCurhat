//
//  ChatPresenter.swift
//  SunibCurhat
//
//  Created by Developer on 20/03/21.
//  Copyright © 2021 Rangga Leo. All rights reserved.
//

import Foundation

class ChatPresenter: ChatViewToPresenter {
    weak var view: ChatPresenterToView?
    var interactor: ChatPresenterToInteractor?
    var router: ChatPresenterToRouter?
    
    private var messages: [Message] = []
    private let chat: Chat
    
    var isSendingImage: Bool = false
    var token_fcm_target: String?
    
    init(chat: Chat) {
        self.chat = chat
    }
    
    func didLoad() {
        view?.setupViews(title: chat.name)
        guard let chatID = chat.id else {
            router?.navigateToPreviousPage(from: view)
            return
        }
        interactor?.listenMessage(chatID: chatID)
    }
    
    func getCurrentSender() -> (id: String, name: String) {
        (RepoMemory.device_id, RepoMemory.user_name ?? "user_name")
    }
    
    func messageForItem(at indexPath: IndexPath) -> Message {
        messages[indexPath.row]
    }
    
    func numberOfSections() -> Int {
        messages.count
    }
    
    func didGetPhoto(message: Message, imageData: Data) {
        guard !isSendingImage, let chatID = chat.id else { return }
        isSendingImage = true
        view?.showLoaderIndicator()
        interactor?.uploadImage(message: message, imageData: imageData, chatID: chatID, isSendingImage: isSendingImage)
    }
    
    func didPressSendButtonWith(text: String) {
        let message = Message(text_message: text)
        interactor?.saveMessage(message: message)
    }
}

extension ChatPresenter: ChatInteractorToPresenter {
    func didSaveMessage(message: Message) {
        view?.scrollToBottom()
        guard let token = token_fcm_target else { return }
        interactor?.sendNotif(token: token, title: chat.name, body: message.text_message)
    }
    
    func failSaveMessage(title: String, message: String) {
        view?.showAlertConfirm(title: title, message: message, okCompletion: nil, cancelCompletion: nil)
    }
    
    func didListenMessage(message: Message) {
        if message.sender.senderId != RepoMemory.device_id {
            token_fcm_target = message.token_fcm
        }
        
        guard !messages.contains(message) else { return }
        messages.append(message)
        messages.sort()
        
        let isLatestMessage = messages.firstIndex(of: message) == (messages.count - 1)
        view?.reloadCollectionView(isLastMessage: isLatestMessage)
    }
    
    func didUploadImage(message: Message) {
        isSendingImage = false
        view?.dismissLoaderIndicator()
        interactor?.saveMessage(message: message)
    }
}
