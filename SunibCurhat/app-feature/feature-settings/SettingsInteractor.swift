// 
//  SettingsInteractor.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 02/03/21.
//  Copyright © 2021 Rangga Leo. All rights reserved.
//

import Foundation

class SettingsInteractor: SettingsPresenterToInteractor {
    weak var presenter: SettingsInteractorToPresenter?
    
    func getSettings() {
        let disk = DiskStorage()
        let storage = CodableStorage(storage: disk)
        storage.fetch(for: ConstGlobal.settings_identifier, object: [SettingItem].self) { [weak self] (result) in
            switch result {
            case .failure(let err):
                self?.presenter?.failGetSettings(title: "Oops", message: err.localizedDescription)
            case .success(let res):
                self?.presenter?.didGetSettings(settingItems: res)
            }
        }
    }
        
}
