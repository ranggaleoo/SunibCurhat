// 
//  NewPostRouter.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 09/02/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import UIKit

class NewPostRouter: NewPostPresenterToRouter {
    
    static func createNewPostModule() -> UIViewController {
        let view: UIViewController & NewPostPresenterToView = NewPostView()
        let presenter: NewPostViewToPresenter & NewPostInteractorToPresenter = NewPostPresenter()
        let interactor: NewPostPresenterToInteractor = NewPostInteractor()
        let router: NewPostPresenterToRouter = NewPostRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
    }
    
    func navigateToMain(from: NewPostPresenterToView?) {
        if let view = from as? UIViewController,
           let feeds = view.navigationController?.viewControllers.first as? FeedsView {
            view.navigationController?.popToViewController(feeds, animated: true)
            feeds.moveFromAddThread()
        }
    }
}
