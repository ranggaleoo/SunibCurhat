// 
//  RegisterRouter.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 07/02/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import UIKit

class RegisterRouter: RegisterPresenterToRouter {
    
    static func createRegisterModule() -> UIViewController {
        let view: UIViewController & RegisterPresenterToView = RegisterView()
        let presenter: RegisterViewToPresenter & RegisterInteractorToPresenter = RegisterPresenter()
        let interactor: RegisterPresenterToInteractor = RegisterInteractor()
        let router: RegisterPresenterToRouter = RegisterRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
    }
    
    func navigateToLogin(view: RegisterPresenterToView?) {
        if let controller = view as? UIViewController {
            let login = LoginRouter.createLoginModule()
            login.modalTransitionStyle = .coverVertical
            login.modalPresentationStyle = .fullScreen
            controller.present(login, animated: true)
        }
    }
}
