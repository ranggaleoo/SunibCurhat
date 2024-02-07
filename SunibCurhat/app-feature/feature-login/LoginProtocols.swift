// 
//  LoginProtocols.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 06/02/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import UIKit


// MARK: View -
protocol LoginPresenterToView: AnyObject {
    var presenter: LoginViewToPresenter? { get set }
    
    func setupViews()
}

// MARK: Interactor -
protocol LoginPresenterToInteractor: AnyObject {
    var presenter: LoginInteractorToPresenter?  { get set }
}


// MARK: Router -
protocol LoginPresenterToRouter: AnyObject {
    static func createLoginModule() -> UIViewController
    
    func navigateToRegister(view: LoginPresenterToView?)
}

// MARK: Presenter -
protocol LoginViewToPresenter: AnyObject {
    var view: LoginPresenterToView? {get set}
    var interactor: LoginPresenterToInteractor? {get set}
    var router: LoginPresenterToRouter? {get set}
    
    func navigateToRegister()
}

protocol LoginInteractorToPresenter: AnyObject {
}
