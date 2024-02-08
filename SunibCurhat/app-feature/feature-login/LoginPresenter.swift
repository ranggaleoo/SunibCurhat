//
//  LoginPresenter.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 06/02/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import Foundation

class LoginPresenter: LoginViewToPresenter {
    weak var view: LoginPresenterToView?
    var interactor: LoginPresenterToInteractor?
    var router: LoginPresenterToRouter?
    
    private var cycleLoginAsAnonymous: Int = 0
    private var email: String? = nil
    private var password: String? = nil
    
    func didLoad() {
        view?.setupViews()
    }
    
    func set(email: String?) {
        self.email = email
    }
    
    func set(password: String?) {
        self.password = password
    }
    
    func getEmail() -> String? {
        return email
    }
    
    func getPassword() -> String? {
        return password
    }
    
    func didClickLogin() {
        view?.startLoader(isFromAnon: false)
        interactor?.login(
            device_id: UDHelpers.shared.getString(key: .device_id),
            email: self.email ?? "",
            password: self.password ?? ""
        )
    }
    
    func didClickLoginAsAnonymous() {
        cycleLoginAsAnonymous += 1
        view?.startLoader(isFromAnon: true)
        interactor?.loginAsAnonymous(device_id: UDHelpers.shared.getString(key: .device_id))
    }
    
    func didClickRegister() {
        router?.navigateToRegister(view: self.view)
    }
    
    func didClickAgreement() {
        debugLog("click agreement")
    }
    
    func didClickPrivacyPolicy() {
        debugLog("click privacy policy")
    }
  
}

extension LoginPresenter: LoginInteractorToPresenter {
    
    func didLogin(user: User, token: String) {
        UDHelpers.shared.set(value: token, key: .access_token)
        UDHelpers.shared.setObject(user, forKey: .user)
        
        view?.stopLoader(isSuccess: true, isFromAnon: false, completion: { [weak self] in
            self?.router?.navigateToSplash(secondaryBackground: nil, view: self?.view)
        })
    }
    
    func didLoginAsAnonymous(user: User, token: String) {
        UDHelpers.shared.set(value: token, key: .access_token)
        UDHelpers.shared.setObject(user, forKey: .user)
        
        view?.stopLoader(isSuccess: true, isFromAnon: true, completion: { [weak self] in
            self?.router?.navigateToSplash(secondaryBackground: true, view: self?.view)
        })
    }
    
    func didRegisterAnonymous() {
        cycleLoginAsAnonymous += 1
        interactor?.loginAsAnonymous(device_id: UDHelpers.shared.getString(key: .device_id))
    }
    
    func failLogin(message: String) {
        email = nil
        password = nil
        view?.showFailLoginMessage(text: message)
        view?.stopLoader(isSuccess: false, isFromAnon: false, completion: nil)
    }
    
    func failLoginAsAnonymous(message: String) {
        if cycleLoginAsAnonymous > 1 {
            cycleLoginAsAnonymous = 0
            view?.showFailLoginMessage(text: message)
            view?.stopLoader(isSuccess: false, isFromAnon: true, completion: nil)
        } else {
            interactor?.registerAnonymous(device_id: UDHelpers.shared.getString(key: .device_id))
        }
    }
    
    func failRegisterAnonymous(message: String) {
        view?.showFailLoginMessage(text: message)
        view?.stopLoader(isSuccess: false, isFromAnon: true, completion: nil)
    }
    
}
