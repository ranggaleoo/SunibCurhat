// 
//  SplashRouter.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 28/02/21.
//  Copyright © 2021 Rangga Leo. All rights reserved.
//

import UIKit

class SplashRouter: SplashPresenterToRouter {
    
    static func createSplashModule() -> UIViewController {
        let view: UIViewController & SplashPresenterToView = SplashView()
        let presenter: SplashViewToPresenter & SplashInteractorToPresenter = SplashPresenter()
        let interactor: SplashPresenterToInteractor = SplashInteractor()
        let router: SplashPresenterToRouter = SplashRouter()
        
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
}
