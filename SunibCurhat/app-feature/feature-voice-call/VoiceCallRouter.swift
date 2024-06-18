// 
//  VoiceCallRouter.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 15/06/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import UIKit

class VoiceCallRouter: VoiceCallPresenterToRouter {
    
    static func createVoiceCallModule(conversation: MediaConversation?) -> UIViewController {
        let view: UIViewController & VoiceCallPresenterToView = VoiceCallView()
        let presenter: VoiceCallViewToPresenter & VoiceCallInteractorToPresenter = VoiceCallPresenter()
        let interactor: VoiceCallPresenterToInteractor = VoiceCallInteractor()
        let router: VoiceCallPresenterToRouter = VoiceCallRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        presenter.mediaConversation = conversation
        interactor.presenter = presenter
        
        return view
    }
}
