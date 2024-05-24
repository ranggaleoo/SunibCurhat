// 
//  ChatsProtocols.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 24/02/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import UIKit

// MARK: View -
protocol ChatsPresenterToView: AnyObject {
    var presenter: ChatsViewToPresenter? { get set }
    
    func setupViews()
    func createConversationFromTimeline(conversation: Conversation)
    func reloadData()
    func dismissRefreshControl()
    func insertRow(at: [IndexPath])
    func reloadRow(at: [IndexPath])
    func showAlertMessage(title: String, message: String)
    func didPopFromChatView(conversation: Conversation?)
}

// MARK: Interactor -
protocol ChatsPresenterToInteractor: AnyObject {
    var presenter: ChatsInteractorToPresenter?  { get set }
    
    func getConversations(request: RequestConversations)
}

// MARK: Router -
protocol ChatsPresenterToRouter: AnyObject {
    static func createChatsModule() -> UIViewController
    func navigateToChat(from: ChatsPresenterToView?, conversation: Conversation?)
}

// MARK: Presenter -
protocol ChatsViewToPresenter: AnyObject {
    var view: ChatsPresenterToView? {get set}
    var interactor: ChatsPresenterToInteractor? {get set}
    var router: ChatsPresenterToRouter? {get set}
    
    func didLoad()
    func didScroll()
    func didRefresh()
    func createConversation(conversation: Conversation)
    func syncConversation(conversation: Conversation?)
    func numberOfRowsInSection() -> Int
    func cellForRowAt(indexPath: IndexPath) -> Conversation?
    func didSelectRowAt(indexPath: IndexPath)
}

protocol ChatsInteractorToPresenter: AnyObject {
    func failRequestConversations(message: String)
}
