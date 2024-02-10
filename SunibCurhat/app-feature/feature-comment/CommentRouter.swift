// 
//  CommentRouter.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 10/02/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import UIKit

class CommentRouter: CommentPresenterToRouter {
    
    static func createCommentModule(timeline_id: Int) -> UIViewController {
        let view: UIViewController & CommentPresenterToView = CommentView()
        let presenter: CommentViewToPresenter & CommentInteractorToPresenter = CommentPresenter()
        let interactor: CommentPresenterToInteractor = CommentInteractor()
        let router: CommentPresenterToRouter = CommentRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        presenter.timeline_id = timeline_id
        interactor.presenter = presenter
        
        return view
    }
    
    func navigateToMain(from: CommentPresenterToView?) {
        if let view = from as? UIViewController,
           let feeds = view.navigationController?.viewControllers.first as? FeedsView
        {
            view.navigationController?.popToViewController(feeds, animated: true)
        }
    }
}
