//
//  ChatPresenter.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 11/03/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import Foundation
import MessageKit
import UIKit
import Cloudinary

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
        view?.updateInputBarToBlocked(name: conversation?.them().first?.name)
        view?.updateUserStatusConnection(
            name: conversation?.them().first?.name,
            status: (conversation?.them().first?.is_online ?? true) ? "Online" : "Offline"
        )
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
    
    func didPickImage(image: UIImage) {
        view?.startLoader()
        interactor?.uploadImage(image: image)
    }
    
    func didTapBlock(block: Bool) {
        if block {
            guard let blocked_by = conversation?.me()?.user_id else { return }
            conversation?.blocked_by = blocked_by
        } else {
            conversation?.blocked_by = nil
        }
        if let convo = conversation {
            interactor?.updateBlock(conversation: convo)
        }
    }
    
    func didTapReport() {
        if let chat = conversation?.chats.last {
            router?.navigateToReport(chat: chat, from: view)
        }
    }
    
    func didTapVoiceCall() {
        if let convo = conversation, let user = convo.me() {
            let mediaConvo = MediaConversation(
                conversation_id: convo.conversation_id,
                user: user,
                role: .Publisher
            )
            interactor?.fetchToken(conversation: mediaConvo)
        }
    }
    
    func didVisibleChatsAsRead(indexPaths: [IndexPath]) {
        var chats: [Chat] = []
        for indexpath in indexPaths {
            if var chat = conversation?.chats.item(at: indexpath.row) {
                if chat.is_read == nil || chat.is_read == false {
                    chat.is_read = true
                    chats.append(chat)
                }
            }
        }
        
        if chats.count > 0 {
            interactor?.markAsRead(chats: chats)
        }
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
            created_at: Date().unixTimestampMilliseconds()
        )
        
        interactor?.sendChat(chat: chat)
    }
    
    func textViewTextDidChangeTo(text: String) {
        //is typing
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty,
              !is_typing,
              let conversation_id = conversation?.conversation_id,
              let from = conversation?.me(),
              let to = conversation?.them().first
        else { return }
        
        is_typing = true
        
        let chat = Chat(
            chat_id: UUID().uuidString,
            conversation_id: conversation_id,
            from: from,
            to: to,
            content: .text(value: text),
            is_typing: true,
            is_read: false,
            created_at: Date().unixTimestampMilliseconds()
        )
        
        interactor?.typing(chat: chat)
    }
    
    func getStateBlocked() -> Bool {
        return conversation?.isBlocked ?? false
    }
    
    func getStateBlockedByMe() -> Bool {
        return conversation?.isBlockedByMe ?? false
    }
    
    func getSender() -> SenderType? {
        return conversation?.me()?.sender()
    }
    
    func isFromCurrentSender(message: MessageType) -> Bool {
        return message.sender.senderId == (conversation?.me()?.sender().senderId ?? "")
    }
    
    func isPreviousMessageSameSender(at indexPath: IndexPath) -> Bool {
        guard indexPath.row - 1 >= 0 else { return false }
        guard let currentUser = conversation?.chats.item(at: indexPath.row)?.from,
              let prevUser = conversation?.chats.item(at: indexPath.row - 1)?.from
        else { return false }
        return currentUser.user_id == prevUser.user_id
    }
    
    func isNextMessageSameSender(at indexPath: IndexPath) -> Bool {
        guard let totalChat = conversation?.chats.count else { return false }
        guard indexPath.row + 1 < totalChat else { return false }
        guard let currentUser = conversation?.chats.item(at: indexPath.row)?.from,
              let nextUser = conversation?.chats.item(at: indexPath.row + 1)?.from
        else { return false }
        return currentUser.user_id == nextUser.user_id
    }
    
    func isReadMessage(at indexPath: IndexPath) -> Bool {
        return conversation?.chats.item(at: indexPath.row)?.is_read ?? false
        
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
    func failSendChat(message: String) {
        view?.showAlert(title: "Oops", message: message)
    }
    
    func didGetRtcToken(conversation: MediaConversation) {
        router?.navigateToVoiceCall(from: view, conversation: conversation)
    }
    
    func didUploadImage(response: CLDUploadResult?) {
        view?.stopLoader()
        guard let conversation_id = conversation?.conversation_id,
              let from = conversation?.me(),
              let to = conversation?.them().first,
              let res = response,
              let urlImage = res.secureUrl,
              let width = res.width,
              let height = res.height
        else { return }
        
        let chat = Chat(
            chat_id: UUID().uuidString,
            conversation_id: conversation_id,
            from: from,
            to: to,
            content: .image(url: urlImage, meta: .init(width: width, height: height)),
            is_typing: false,
            is_read: false,
            created_at: Date().unixTimestampMilliseconds()
        )
        
        interactor?.sendChat(chat: chat)
    }
    
    func failUploadImage(message: String) {
        view?.stopLoader()
        view?.showAlert(title: "Oops", message: message)
    }
    
    func failUpdateBlockUser(message: String) {
        view?.showAlert(title: "Oops", message: message)
    }
}

extension ChatPresenter: SocketDelegate {
    func didUserOnline(user: User) {
        if conversation?.them().first?.user_id == user.user_id {
            for i in 0...((conversation?.users.count ?? 0) - 1) {
                if let foundUser = conversation?.users.item(at: i),
                   foundUser.user_id == user.user_id {
                    conversation?.users[i].is_online = user.is_online
                    view?.updateUserStatusConnection(name: user.name, status: "Hi I'am Online!")
                    break
                }
            }
        }
    }
    
    func didUserOffline(user: User) {
        if conversation?.them().first?.user_id == user.user_id {
            for i in 0...((conversation?.users.count ?? 0) - 1) {
                if let foundUser = conversation?.users.item(at: i),
                   foundUser.user_id == user.user_id {
                    conversation?.users[i].is_online = user.is_online
                    view?.updateUserStatusConnection(name: user.name, status: "I'am Offline Right Now, BRB!")
                    break
                }
            }
        }
    }
    
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
        if conversation?.them().first?.user_id == chat.from?.user_id {
            is_typing = true
        }
        
        if let typing = chat.is_typing, typing && is_typing {
            view?.showTyping(chat: chat)
        }
    }
    
    func didMarkChatsRead(chats: [Chat]) {
        for newChat in chats {
            for i in 0...((conversation?.chats.count ?? 0) - 1) {
                if newChat.chat_id == conversation?.chats.item(at: i)?.chat_id {
                    conversation?.chats[i].is_read = newChat.is_read
                }
            }
        }
        view?.reloadAndKeepOffset()
    }
    
    func didReceiveChat(chat: Chat) {
        conversation?.chats.append(chat)
        view?.reloadCollectionView()
    }
    
    func failGetChats(message: String) {
        view?.showAlert(title: "Oops", message: message)
    }
    
    func didUpdateBlockUser(conversation: Conversation) {
        self.conversation = conversation
        view?.updateInputBarToBlocked(name: conversation.them().first?.name)
    }
    
    func failUpdateBlock(message: String) {
        view?.showAlert(title: "Oops", message: message)
    }
}
