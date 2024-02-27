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
        let device_id = UDHelpers.shared.getString(key: .device_id) ?? UUID().uuidString
        view?.startLoader(isFromAnon: false)
        interactor?.login(
            device_id: device_id,
            email: self.email ?? "",
            password: self.password ?? ""
        )
    }
    
    func didClickLoginAsAnonymous() {
        let device_id = UDHelpers.shared.getString(key: .device_id) ?? UUID().uuidString
        view?.startLoader(isFromAnon: true)
        interactor?.loginAsAnonymous(device_id: device_id)
    }
    
    func didClickRegister() {
        router?.navigateToRegister(view: self.view)
    }
    
    func didClickAgreement() {
        let preferences = UDHelpers.shared.getObject(type: Preferences.self, forKey: .preferences_key)
        router?.navigateToUserAgreement(from: view, url: preferences?.urls?.user_agreement)
    }
    
    func didClickPrivacyPolicy() {
        let preferences = UDHelpers.shared.getObject(type: Preferences.self, forKey: .preferences_key)
        router?.navigateToPrivacyPolicy(from: view, url: preferences?.urls?.privacy_policy)
    }
  
}

extension LoginPresenter: LoginInteractorToPresenter {
    
    func didLogin(user: User, accessToken: String, refreshToken: String) {
        UDHelpers.shared.set(value: refreshToken, key: .refresh_token)
        UDHelpers.shared.set(value: accessToken, key: .access_token)
        UDHelpers.shared.setObject(user, forKey: .user)
        
        view?.stopLoader(isSuccess: true, isFromAnon: false, completion: { [weak self] in
            self?.router?.navigateToSplash(secondaryBackground: nil, view: self?.view)
        })
    }
    
    func didLoginAsAnonymous(user: User, accessToken: String, refreshToken: String) {
        UDHelpers.shared.set(value: refreshToken, key: .refresh_token)
        UDHelpers.shared.set(value: accessToken, key: .access_token)
        UDHelpers.shared.setObject(user, forKey: .user)
        
        view?.stopLoader(isSuccess: true, isFromAnon: true, completion: { [weak self] in
            self?.router?.navigateToSplash(secondaryBackground: true, view: self?.view)
        })
    }
    
    func failLogin(message: String) {
        email = nil
        password = nil
        view?.showFailLoginMessage(text: message)
        view?.stopLoader(isSuccess: false, isFromAnon: false, completion: nil)
    }
    
    func failLoginAsAnonymous(message: String) {
        view?.showFailLoginMessage(text: message)
        view?.stopLoader(isSuccess: false, isFromAnon: true, completion: nil)
    }
}
