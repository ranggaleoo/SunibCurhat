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
    
    func navigateToChats(to: ChatsPresenterToView?, conversation: Conversation?) {
        if let chats = to as? ChatsView {
            chats.didPopFromChatView(conversation: conversation)
        }
    }
    
    func navigateToReport(chat: Chat, from: ChatPresenterToView?) {
        if let view = from as? UIViewController {
            let storyboad = UIStoryboard(name: "Report", bundle: nil)
            if let vc = storyboad.instantiateViewController(withIdentifier: "view_report") as? ReportViewController {
                vc.chat = chat
                view.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func navigateToCall(from: ChatPresenterToView?, call: Call?, callType: Call.CallType?) {
        if let view = from as? UIViewController, let call = call {
            let callView = CallRouter.createCallModule(call: call, callType: callType)
            callView.modalTransitionStyle = .crossDissolve
            callView.modalPresentationStyle = .fullScreen
            view.present(callView, animated: true)
        }
    }
}
