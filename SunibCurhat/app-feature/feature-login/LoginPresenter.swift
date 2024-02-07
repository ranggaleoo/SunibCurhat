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
    
    func navigateToRegister() {
        router?.navigateToRegister(view: self.view)
    }
  
}

extension LoginPresenter: LoginInteractorToPresenter {
    
}
