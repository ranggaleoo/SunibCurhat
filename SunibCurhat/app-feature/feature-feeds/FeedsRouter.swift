// 
//  FeedsRouter.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 27/11/20.
//  Copyright © 2020 Rangga Leo. All rights reserved.
//

import UIKit

class FeedsRouter: FeedsPresenterToRouter {
    
    static func createFeedsModule() -> UIViewController {
        let view: UIViewController & FeedsPresenterToView = FeedsView()
        let presenter: FeedsViewToPresenter & FeedsInteractorToPresenter = FeedsPresenter()
        let interactor: FeedsPresenterToInteractor = FeedsInteractor()
        let router: FeedsPresenterToRouter = FeedsRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
    }
}
