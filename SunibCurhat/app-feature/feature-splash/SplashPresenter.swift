//
//  SplashPresenter.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 28/02/21.
//  Copyright © 2021 Rangga Leo. All rights reserved.
//

import Foundation

class SplashPresenter: SplashViewToPresenter {
    weak var view: SplashPresenterToView?
    var interactor: SplashPresenterToInteractor?
    var router: SplashPresenterToRouter?
    
    private var settingIsAvailable: Bool = false {
        didSet {
            if settingIsAvailable {
                interactor?.getEndpoint()
            }
        }
    }
    
    func didLoad() {
        view?.setupViews()
        view?.startLoader()
        initialSettings()
    }
    
    func initialSettings() {
        settingIsAvailable = false
        let disk = DiskStorage()
        let storage = CodableStorage(storage: disk)
        var settings: [SettingItem] = []
        settings.append(SettingItem(title: "Push Notification", description: "currently the push notification feature is used for chat notifications", type: .pushNotification, defaultValue: true))
        
        storage.fetch(for: ConstGlobal.settings_identifier, object: [SettingItem].self) { [weak self] (result) in
            switch result {
            case .failure(let err):
                do {
                    try storage.save(settings, for: ConstGlobal.settings_identifier)
                    ConstGlobal.setting_list = settings
                    self?.settingIsAvailable = true
                } catch {
                    debugLog(error.localizedDescription)
                    debugLog(err.localizedDescription)
                }
                
            case .success(let res):
                debugLog(res)
                if res.count == settings.count {
                    ConstGlobal.setting_list = settings
                    self?.settingIsAvailable = true
                } else {
                    do {
                        try storage.save(settings, for: ConstGlobal.settings_identifier)
                        ConstGlobal.setting_list = settings
                        self?.settingIsAvailable = true
                    } catch {
                        debugLog(error.localizedDescription)
                    }
                }
            }
        }
    }
}

extension SplashPresenter: SplashInteractorToPresenter {
    func didGetEndpoint(data: EndpointResponse) {
//        URLConst.server = data.endpoint
//        view?.stopLoader()
//        router?.navigateToMain(from: view)
        URLConst.server = "http://localhost:8888"
        self.interactor?.getPreferences()
    }
    
    func didGetPreferences(data: Preferences) {
        UDHelpers.shared.setObject(data, forKey: .preferences_key)
        self.interactor?.refreshToken()
    }
    
    func didGetToken(data: RefreshTokenData) {
        UDHelpers.shared.set(value: data.access_token, key: .access_token)
        self.interactor?.getUser()
    }
    
    func didGetUser(data: User) {
        UDHelpers.shared.set(value: data, key: .user)
        view?.stopLoader()
        router?.navigateToMain(from: view)
    }
    
    func failGetEndpoint(title: String, message: String) {
        view?.stopLoader()
        view?.showAlertConfirm(title: title, message: message, okCompletion: { [weak self] in
            self?.view?.startLoader()
            self?.interactor?.getEndpoint()
        }, cancelCompletion: nil)
    }
    
    func failGetPreferences(title: String, message: String) {
        view?.stopLoader()
        view?.showAlertConfirm(title: title, message: message, okCompletion: { [weak self] in
            self?.view?.startLoader()
            self?.interactor?.getPreferences()
        }, cancelCompletion: nil)
    }
    
    func failGetToken(title: String, message: String) {
        view?.stopLoader()
        view?.showAlertConfirm(title: title, message: message, okCompletion: { [weak self] in
            if let view = self?.view {
                self?.router?.navigateToLogin(from: view)
            }
        }, cancelCompletion: nil)
    }
    
    func failGetUser(title: String, message: String) {
        view?.stopLoader()
        view?.showAlertConfirm(title: title, message: message, okCompletion: { [weak self] in
            self?.view?.startLoader()
            self?.interactor?.getUser()
        }, cancelCompletion: nil)
    }
}
