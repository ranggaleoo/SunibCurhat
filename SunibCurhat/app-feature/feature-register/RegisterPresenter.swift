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
    
    func navigateToLogin() {
        router?.navigateToLogin(view: self.view)
    }
}

extension RegisterPresenter: RegisterInteractorToPresenter {
}
