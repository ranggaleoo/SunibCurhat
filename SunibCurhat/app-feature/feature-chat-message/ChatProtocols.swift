// 
//  ChatProtocols.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 11/03/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import UIKit
import MessageKit

// MARK: View -
protocol ChatPresenterToView: AnyObject {
    var presenter: ChatViewToPresenter? { get set }
    
    func setupViews(name: String?)
    func reloadCollectionView()
    func reloadAndKeepOffset()
    func showAlert(title: String, message: String)
    func showTyping(chat: Chat)
}

// MARK: Interactor -
protocol ChatPresenterToInteractor: AnyObject {
    var presenter: ChatInteractorToPresenter?  { get set }
    
    func getChats(request: RequestChats)
    func sendChat(chat: Chat)
    func typing(chat: Chat)
}

// MARK: Router -
protocol ChatPresenterToRouter: AnyObject {
    static func createChatModule(conversation: Conversation?) -> MessagesViewController
    func navigateToChats(to: ChatsPresenterToView?, conversation: Conversation?)
}

// MARK: Presenter -
protocol ChatViewToPresenter: AnyObject {
    var view: ChatPresenterToView? {get set}
    var interactor: ChatPresenterToInteractor? {get set}
    var router: ChatPresenterToRouter? {get set}
    
    func didLoad()
    func didScroll()
    func didPop(to: ChatsPresenterToView)
    func set(conversation: Conversation?)
    func typingIsStopped()
    
    // input bar
    func didPressSendButtonWith(text: String)
    func textViewTextDidChangeTo(text: String)
    
    // data source
    func getSender() -> SenderType?
    func isFromCurrentSender(message: MessageType) -> Bool
    func messageForItem(at indexPath: IndexPath) -> MessageType?
    func numberOfSections() -> Int?
    func numberOfItems(inSection section: Int) -> Int?
}

protocol ChatInteractorToPresenter: AnyObject {
    func didSendChat()
    func failSendChat(message: String)
}
