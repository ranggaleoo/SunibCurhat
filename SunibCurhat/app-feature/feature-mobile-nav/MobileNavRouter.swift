// 
//  MobileNavRouter.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 05/03/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import UIKit

class MobileNavRouter: MobileNavPresenterToRouter {
    
    static func createMobileNavModule(data: [MobileNavigationPageSection]?) -> UIViewController {
        let view: UIViewController & MobileNavPresenterToView = MobileNavView()
        let presenter: MobileNavViewToPresenter & MobileNavInteractorToPresenter = MobileNavPresenter(sections: data)
        let interactor: MobileNavPresenterToInteractor = MobileNavInteractor()
        let router: MobileNavPresenterToRouter = MobileNavRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
    }
    
    func navigateToMobileNav(from: MobileNavPresenterToView?, data: [MobileNavigationPageSection]?) {
        if let view = from as? UIViewController {
            let mobileNav = MobileNavRouter.createMobileNavModule(data: data)
            mobileNav.hidesBottomBarWhenPushed = true
            view.navigationController?.pushViewController(mobileNav, animated: true)
        }
    }
    
    func navigateToWebView(from: MobileNavPresenterToView?, url: URL?) {
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
