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
    func showFailLoginMessage(text: String)
    func startLoader(isFromAnon: Bool)
    func stopLoader(isSuccess: Bool, isFromAnon: Bool, completion: (() -> Void)?)
}

// MARK: Interactor -
protocol LoginPresenterToInteractor: AnyObject {
    var presenter: LoginInteractorToPresenter?  { get set }
    
    func login(device_id: String, email: String, password: String)
    func loginAsAnonymous(device_id: String)
    func registerAnonymous(device_id: String)
}


// MARK: Router -
protocol LoginPresenterToRouter: AnyObject {
    static func createLoginModule() -> UIViewController
    
    func navigateToRegister(view: LoginPresenterToView?)
    func navigateToSplash(secondaryBackground: Bool?, view: LoginPresenterToView?)
}

// MARK: Presenter -
protocol LoginViewToPresenter: AnyObject {
    var view: LoginPresenterToView? {get set}
    var interactor: LoginPresenterToInteractor? {get set}
    var router: LoginPresenterToRouter? {get set}
    
    func didLoad()
    func set(email: String?)
    func set(password: String?)
    func getEmail() -> String?
    func getPassword() -> String?
    func didClickLogin()
    func didClickLoginAsAnonymous()
    func didClickRegister()
    func didClickAgreement()
    func didClickPrivacyPolicy()
}

protocol LoginInteractorToPresenter: AnyObject {
    func didLogin(user: User, token: String)
    func didLoginAsAnonymous(user: User, token: String)
    func didRegisterAnonymous()
    func failLogin(message: String)
    func failLoginAsAnonymous(message: String)
    func failRegisterAnonymous(message: String)
}
