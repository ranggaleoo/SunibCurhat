// 
//  LoginInteractor.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 06/02/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import Foundation

class LoginInteractor: LoginPresenterToInteractor {
    weak var presenter: LoginInteractorToPresenter?
    
    func login(device_id: String, email: String, password: String) {
        LoginService.shared.login(device_id: device_id, email: email, password: password) { [weak self] (result) in
            switch result {
            case .success(let res):
                if res.success, let data = res.data {
                    self?.presenter?.didLogin(user: data.user, token: data.access_token)
                } else {
                    self?.presenter?.failLogin(message: res.message)
                }
            case .failure(let err):
                self?.presenter?.failLogin(message: err.localizedDescription)
            }
        }
    }
    
    func loginAsAnonymous(device_id: String) {
        LoginService.shared.loginAsAnonymous(device_id: device_id) { [weak self] (result) in
            switch result {
            case .success(let res):
                if res.success, let data = res.data {
                    self?.presenter?.didLoginAsAnonymous(user: data.user, token: data.access_token)
                } else {
                    self?.presenter?.failLoginAsAnonymous(message: res.message)
                }
            case .failure(let err):
                self?.presenter?.failLoginAsAnonymous(message: err.localizedDescription)
            }
        }
    }
    
    func registerAnonymous(device_id: String) {
        LoginService.shared.registerAnonymous(device_id: device_id) { [weak self] (result) in
            switch result {
            case .success(let res):
                if res.success {
                    self?.presenter?.didRegisterAnonymous()
                } else {
                    self?.presenter?.failRegisterAnonymous(message: res.message)
                }
            case .failure(let err):
                self?.presenter?.failRegisterAnonymous(message: err.localizedDescription)
            }
        }
    }
        
}
