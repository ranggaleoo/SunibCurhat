//
//  RegisterPresenter.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 07/02/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import Foundation

class RegisterPresenter: RegisterViewToPresenter {
    weak var view: RegisterPresenterToView?
    var interactor: RegisterPresenterToInteractor?
    var router: RegisterPresenterToRouter?
    
    private var email: String? = nil
    private var password: String? = nil
    private var confirm_password: String? = nil
    
    func didLoad() {
        view?.setupViews()
    }
    
    func set(email: String?) {
        self.email = email
    }
    
    func set(password: String?) {
        self.password = password
    }
    
    func set(confirm_password: String?) {
        self.confirm_password = confirm_password
    }
    
    func getEmail() -> String? {
        return email
    }
    
    func getPassword() -> String? {
        return password
    }
    
    func getConfirmPassword() -> String? {
        return confirm_password
    }
    
    func didClickRegister() {
        view?.startLoader()
        interactor?.register(
            device_id: UDHelpers.shared.getString(key: .device_id),
            email: self.email ?? "",
            password: self.password ?? ""
        )
    }
    
    func didClickLogin() {
        router?.navigateToLogin(view: self.view)
    }
    
    func didClickAgreement() {
        //
    }
    
    func didClickPrivacyPolicy() {
        //
    }
}

extension RegisterPresenter: RegisterInteractorToPresenter {
    func didRegister() {        
        self.interactor?.login(
            device_id: UDHelpers.shared.getString(key: .device_id),
            email: self.email ?? "",
            password: self.password ?? ""
        )
    }
    
    func didLogin(user: User, token: String) {
        UDHelpers.shared.setObject(user, forKey: .user)
        UDHelpers.shared.set(value: token, key: .access_token)
        
        view?.stopLoader(isSuccess: true, completion: { [weak self] in
            self?.router?.navigateToSplash(view: self?.view)
        })
    }
        
    func failRegister(message: String) {
        email = nil
        password = nil
        confirm_password = nil
        view?.showFailRegisterMessage(text: message)
        view?.stopLoader(isSuccess: false, completion: nil)
    }
    
    func failLogin(message: String) {
        email = nil
        password = nil
        confirm_password = nil
        view?.showFailRegisterMessage(text: message)
        view?.stopLoader(isSuccess: false, completion: nil)
    }
}
