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
    
    func setupViews()
    func enableSwitcher(indexPath: IndexPath)
    func reloadTableView()
    func showLoaderIndicator()
    func dismissLoaderIndicator()
    func showAlertConfirm(title: String, message: String, okCompletion: (() -> Void)?, cancelCompletion: (()-> Void)?)
}

// MARK: Interactor -
protocol SettingsPresenterToInteractor: class {
    var presenter: SettingsInteractorToPresenter?  { get set }
    
    func getSettings()
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
    
    func didLoad()
    func numberOfRowsInSection() -> Int
    func cellForRowAt(indexPath: IndexPath) -> SettingItem
    func saveSettingSwitch(indexPath: IndexPath, isOn: Bool)
}

protocol SettingsInteractorToPresenter: class {
    func didGetSettings(settingItems: [SettingItem])
    func failGetSettings(title: String, message: String)
}
