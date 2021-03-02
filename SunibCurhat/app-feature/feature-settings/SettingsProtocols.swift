// 
//  SettingsProtocols.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 02/03/21.
//  Copyright © 2021 Rangga Leo. All rights reserved.
//

import UIKit


// MARK: View -
protocol SettingsPresenterToView: class {
    var presenter: SettingsViewToPresenter? { get set }
}

// MARK: Interactor -
protocol SettingsPresenterToInteractor: class {
    var presenter: SettingsInteractorToPresenter?  { get set }
}


// MARK: Router -
protocol SettingsPresenterToRouter: class {
    static func createSettingsModule() -> UIViewController
}

// MARK: Presenter -
protocol SettingsViewToPresenter: class {
    var view: SettingsPresenterToView? {get set}
    var interactor: SettingsPresenterToInteractor? {get set}
    var router: SettingsPresenterToRouter? {get set}
}

protocol SettingsInteractorToPresenter: class {
}
