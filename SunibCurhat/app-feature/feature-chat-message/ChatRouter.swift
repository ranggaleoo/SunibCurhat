// 
//  ChatRouter.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 11/03/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import UIKit
import MessageKit

class ChatRouter: ChatPresenterToRouter {
    
    static func createChatModule(conversation: Conversation?) -> MessagesViewController {
        let view: MessagesViewController & ChatPresenterToView = ChatView()
        let presenter: ChatViewToPresenter & ChatInteractorToPresenter = ChatPresenter()
        let interactor: ChatPresenterToInteractor = ChatInteractor()
        let router: ChatPresenterToRouter = ChatRouter()
        
        view.presenter = presenter
        presenter.set(conversation: conversation)
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
    }
}
