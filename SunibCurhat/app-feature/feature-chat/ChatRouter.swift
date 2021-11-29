// 
//  ChatRouter.swift
//  SunibCurhat
//
//  Created by Developer on 20/03/21.
//  Copyright © 2021 Rangga Leo. All rights reserved.
//

import UIKit

class ChatRouter: ChatPresenterToRouter {
    
    static func createChatModule(chat: Chat) -> UIViewController {
        let view: UIViewController & ChatPresenterToView = ChatView()
        let presenter: ChatViewToPresenter & ChatInteractorToPresenter = ChatPresenter(chat: chat)
        let interactor: ChatPresenterToInteractor = ChatInteractor()
        let router: ChatPresenterToRouter = ChatRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
    }
    
    func navigateToPreviousPage(from: ChatPresenterToView?) {
        if let controller = from as? UIViewController {
            controller.navigationController?.popViewController(animated: true)
        }
    }
}
