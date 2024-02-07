// 
//  RegisterProtocols.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 07/02/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import UIKit

// MARK: View -
protocol RegisterPresenterToView: AnyObject {
    var presenter: RegisterViewToPresenter? { get set }
    
    func setupViews()
}

// MARK: Interactor -
protocol RegisterPresenterToInteractor: AnyObject {
    var presenter: RegisterInteractorToPresenter?  { get set }
}

// MARK: Router -
protocol RegisterPresenterToRouter: AnyObject {
    static func createRegisterModule() -> UIViewController
    
    func navigateToLogin(view: RegisterPresenterToView?)
}

// MARK: Presenter -
protocol RegisterViewToPresenter: AnyObject {
    var view: RegisterPresenterToView? {get set}
    var interactor: RegisterPresenterToInteractor? {get set}
    var router: RegisterPresenterToRouter? {get set}
    
    func navigateToLogin()
}

protocol RegisterInteractorToPresenter: AnyObject {
}
