//
//  SettingsPresenter.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 02/03/21.
//  Copyright © 2021 Rangga Leo. All rights reserved.
//

import Foundation

class SettingsPresenter: SettingsViewToPresenter {
    weak var view: SettingsPresenterToView?
    var interactor: SettingsPresenterToInteractor?
    var router: SettingsPresenterToRouter?
  
}

extension SettingsPresenter: SettingsInteractorToPresenter {
    
}
