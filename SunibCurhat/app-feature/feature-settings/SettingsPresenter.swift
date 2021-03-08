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
    
    var items: [SettingItem] = []
    
    func didLoad() {
        view?.setupViews()
        view?.showLoaderIndicator()
        interactor?.getSettings()
    }
    
    func numberOfRowsInSection() -> Int {
        items.count
    }
    
    func cellForRowAt(indexPath: IndexPath) -> SettingItem {
        items[indexPath.row]
    }
    
    func saveSettingSwitch(indexPath: IndexPath, isOn: Bool) {
        let disk = DiskStorage()
        let storage = CodableStorage(storage: disk)
        items[indexPath.row].usersValue = isOn
        view?.showLoaderIndicator()
        do {
            try storage.save(items, for: ConstGlobal.settings_identifier)
            ConstGlobal.setting_list = items
            view?.dismissLoaderIndicator()
            view?.enableSwitcher(indexPath: indexPath)
        } catch {
            debugLog(error)
            view?.dismissLoaderIndicator()
        }
    }
}

extension SettingsPresenter: SettingsInteractorToPresenter {
    func didGetSettings(settingItems: [SettingItem]) {
        items = settingItems
        view?.dismissLoaderIndicator()
        view?.reloadTableView()
    }
    
    func failGetSettings(title: String, message: String) {
        view?.dismissLoaderIndicator()
        view?.showAlertConfirm(title: title, message: message, okCompletion: { [weak self] in
            self?.interactor?.getSettings()
        }, cancelCompletion: nil)
    }
}
