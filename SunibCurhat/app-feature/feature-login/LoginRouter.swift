// 
//  LoginRouter.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 06/02/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import UIKit

class LoginRouter: LoginPresenterToRouter {
    
    static func createLoginModule() -> UIViewController {
        let view: UIViewController & LoginPresenterToView = LoginView()
        let presenter: LoginViewToPresenter & LoginInteractorToPresenter = LoginPresenter()
        let interactor: LoginPresenterToInteractor = LoginInteractor()
        let router: LoginPresenterToRouter = LoginRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
    }
    
    func navigateToRegister(view: LoginPresenterToView?) {
        if let controller = view as? UIViewController {
            let register = RegisterRouter.createRegisterModule()
            register.modalTransitionStyle = .coverVertical
            register.modalPresentationStyle = .fullScreen
            controller.present(register, animated: true)
        }
    }
    
    func navigateToSplash(secondaryBackground: Bool?, view: LoginPresenterToView?) {
        if let controller = view as? UIViewController {
            let splash = SplashRouter.createSplashModule(secondaryBackground: secondaryBackground)
            splash.modalTransitionStyle = .crossDissolve
            splash.modalPresentationStyle = .fullScreen
            controller.present(splash, animated: true)
        }
    }
}
