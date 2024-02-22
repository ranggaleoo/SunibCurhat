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
    func showFailRegisterMessage(text: String)
    func startLoader()
    func stopLoader(isSuccess: Bool, completion: (() -> Void)?)
}

// MARK: Interactor -
protocol RegisterPresenterToInteractor: AnyObject {
    var presenter: RegisterInteractorToPresenter?  { get set }
    
    func login(device_id: String, email: String, password: String)
    func register(device_id: String, email: String, password: String)
}

// MARK: Router -
protocol RegisterPresenterToRouter: AnyObject {
    static func createRegisterModule() -> UIViewController
    
    func navigateToLogin(view: RegisterPresenterToView?)
    func navigateToSplash(view: RegisterPresenterToView?)
    func navigateToPrivacy(from: RegisterPresenterToView?, url: String?)
    func navigateToAgreement(from: RegisterPresenterToView?, url: String?)
}

// MARK: Presenter -
protocol RegisterViewToPresenter: AnyObject {
    var view: RegisterPresenterToView? {get set}
    var interactor: RegisterPresenterToInteractor? {get set}
    var router: RegisterPresenterToRouter? {get set}
    
    func didLoad()
    func set(email: String?)
    func set(password: String?)
    func set(confirm_password: String?)
    func getEmail() -> String?
    func getPassword() -> String?
    func getConfirmPassword() -> String?
    func didClickRegister()
    func didClickLogin()
    func didClickAgreement()
    func didClickPrivacyPolicy()
}

protocol RegisterInteractorToPresenter: AnyObject {
    func didRegister()
    func didLogin(user: User, token: String)
    func failRegister(message: String)
    func failLogin(message: String)
}
