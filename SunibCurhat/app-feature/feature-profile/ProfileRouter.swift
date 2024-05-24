// 
//  ProfileRouter.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 05/03/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import UIKit

class ProfileRouter: ProfilePresenterToRouter {
    
    static func createProfileModule() -> UIViewController {
        let view: UIViewController & ProfilePresenterToView = ProfileView()
        let presenter: ProfileViewToPresenter & ProfileInteractorToPresenter = ProfilePresenter()
        let interactor: ProfilePresenterToInteractor = ProfileInteractor()
        let router: ProfilePresenterToRouter = ProfileRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
    }
    
    func navigateToLogin(from: ProfilePresenterToView?) {
        if let view = from as? UIViewController {
            let login = LoginRouter.createLoginModule()
            login.hidesBottomBarWhenPushed = true
            login.modalPresentationStyle = .fullScreen
            login.modalTransitionStyle = .crossDissolve
            view.present(login, animated: true)
        }
    }
    
    func navigateToMobileNav(from: ProfilePresenterToView?, data: [MobileNavigationPageSection]?) {
        if let view = from as? UIViewController {
            let mobileNav = MobileNavRouter.createMobileNavModule(data: data)
            mobileNav.hidesBottomBarWhenPushed = true
            view.navigationController?.pushViewController(mobileNav, animated: true)
        }
    }
    
    func navigateToWebView(from: ProfilePresenterToView?, url: URL?) {
        if let view = from as? UIViewController,
           let urlString = url {
            let webView = WKWebViewController()
            view.present(webView, animated: true) {
                webView.loadWebView(url: urlString, params: nil)
            }
        }
    }
    
    func navigateToExternalURL(url: URL?) {
        guard let url = url else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}
