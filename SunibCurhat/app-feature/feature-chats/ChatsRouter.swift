// 
//  ChatsRouter.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 24/02/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import UIKit

class ChatsRouter: ChatsPresenterToRouter {
    
    static func createChatsModule() -> UIViewController {
        let view: UIViewController & ChatsPresenterToView = ChatsView()
        let presenter: ChatsViewToPresenter & ChatsInteractorToPresenter = ChatsPresenter()
        let interactor: ChatsPresenterToInteractor = ChatsInteractor()
        let router: ChatsPresenterToRouter = ChatsRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
    }
    
    func navigateToChat(from: ChatsPresenterToView?, conversation: Conversation?) {
        if let view = from as? UIViewController {
            let chat = ChatRouter.createChatModule(conversation: conversation)
            chat.hidesBottomBarWhenPushed = true
            view.navigationController?.pushViewController(chat, animated: true)
        }
    }
}
