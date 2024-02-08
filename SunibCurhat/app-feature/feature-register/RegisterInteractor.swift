// 
//  RegisterInteractor.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 07/02/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import Foundation

class RegisterInteractor: RegisterPresenterToInteractor {
    weak var presenter: RegisterInteractorToPresenter?
    
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
    
    func register(device_id: String, email: String, password: String) {
        RegisterService.shared.register(device_id: device_id, email: email, password: password) { [weak self] (result) in
            switch result {
            case .success(let res):
                if res.success {
                    self?.presenter?.didRegister()
                } else {
                    self?.presenter?.failRegister(message: res.message)
                }
            case .failure(let err):
                self?.presenter?.failRegister(message: err.localizedDescription)
            }
        }
    }
}
