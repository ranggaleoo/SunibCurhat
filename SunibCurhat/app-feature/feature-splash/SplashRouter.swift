// 
//  SplashRouter.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 28/02/21.
//  Copyright © 2021 Rangga Leo. All rights reserved.
//

import UIKit

class SplashRouter: SplashPresenterToRouter {
    
    static func createSplashModule(secondaryBackground: Bool?) -> UIViewController {
        let view: UIViewController & SplashPresenterToView = SplashView()
        let presenter: SplashViewToPresenter & SplashInteractorToPresenter = SplashPresenter()
        let interactor: SplashPresenterToInteractor = SplashInteractor()
        let router: SplashPresenterToRouter = SplashRouter()
        
        if let secondaryBG = secondaryBackground, secondaryBG {
            view.splashBackgroundColor = UINCColor.secondary
        }
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
    }
    
    func navigateToMain(from: SplashPresenterToView?) {
        if let vc = from as? UIViewController {
            let main = MainTabBarController()
            main.modalTransitionStyle = .crossDissolve
            main.modalPresentationStyle = .fullScreen
            vc.present(main, animated: true, completion: nil)
        }
    }
    
    func navigateToLogin(from: SplashPresenterToView?) {
        if let controller = from as? UIViewController {
            let login = LoginRouter.createLoginModule()
            login.modalTransitionStyle = .crossDissolve
            login.modalPresentationStyle = .fullScreen
            controller.present(login, animated: true)
        }
    }
    
    func navigateToCustom(from: SplashPresenterToView?, to: UIViewController?) {
        if let view = from as? UIViewController {
            if let toCustom = to {
                view.present(toCustom, animated: true)
            } else {
                navigateToMain(from: from)
            }
        }
    }
}
