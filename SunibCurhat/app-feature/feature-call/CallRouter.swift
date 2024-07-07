// 
//  CallRouter.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 19/06/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import UIKit

class CallRouter: CallPresenterToRouter {
    
    static func createCallModule(mediaConversation: MediaConversation?, medium: CallMediumType?) -> UIViewController {
        let view: UIViewController & CallPresenterToView = CallView()
        let presenter: CallViewToPresenter & CallInteractorToPresenter = CallPresenter()
        let interactor: CallPresenterToInteractor = CallInteractor()
        let router: CallPresenterToRouter = CallRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        presenter.mediaConversation = mediaConversation
        presenter.callMediumType = medium != nil ? medium : .VoiceCall
        interactor.presenter = presenter
        
        return view
    }
    
    func navigateToParent(from: CallPresenterToView?) {
        if let view = from as? UIViewController {
            view.dismiss(animated: true)
        }
    }
}
