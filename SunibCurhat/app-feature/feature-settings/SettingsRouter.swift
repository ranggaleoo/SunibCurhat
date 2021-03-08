// 
//  SettingsRouter.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 02/03/21.
//  Copyright © 2021 Rangga Leo. All rights reserved.
//

import UIKit

class SettingsRouter: SettingsPresenterToRouter {
    
    static func createSettingsModule() -> UIViewController {
        let view: UIViewController & SettingsPresenterToView = SettingsView()
        let presenter: SettingsViewToPresenter & SettingsInteractorToPresenter = SettingsPresenter()
        let interactor: SettingsPresenterToInteractor = SettingsInteractor()
        let router: SettingsPresenterToRouter = SettingsRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
    }
}
