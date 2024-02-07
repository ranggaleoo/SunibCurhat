// 
//  SplashInteractor.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 28/02/21.
//  Copyright © 2021 Rangga Leo. All rights reserved.
//

import Foundation

class SplashInteractor: SplashPresenterToInteractor {
    weak var presenter: SplashInteractorToPresenter?
    
    func getEndpoint() {
        MainService.shared.getEndpoint { [weak self] (result) in
            switch result {
            case .failure(let err):
                self?.presenter?.failGetEndpoint(title: "Oops", message: err.localizedDescription + ", Try Again?")
            case .success(let res):
                if let data = res.data, res.success {
                    self?.presenter?.didGetEndpoint(data: data)
                } else {
                    self?.presenter?.failGetEndpoint(title: "Oops", message: res.message + ", Try Again?")
                }
            }
        }
    }
    
    func getPreferences() {
        MainService.shared.getPreferences { [weak self] (result) in
            switch result {
            case .failure(let err):
                self?.presenter?.failGetPreferences(title: "Oops", message: err.localizedDescription + ", Try Again?")
            case .success(let res):
                if let data = res.data, res.success {
                    self?.presenter?.didGetPreferences(data: data)
                } else {
                    self?.presenter?.failGetPreferences(title: "Oops", message: res.message + ", Try Again?")
                }
            }
        }
    }
    
    func refreshToken() {
        MainService.shared.refreshToken { [weak self] (result) in
            switch result {
            case .failure(let err):
                self?.presenter?.failGetToken(title: "Oops", message: err.localizedDescription + ", Go To Login?")
            case .success(let res):
                if let token = res.data, res.success {
                    self?.presenter?.didGetToken(data: token)
                } else {
                    self?.presenter?.failGetToken(title: "Oops", message: res.message + ", Go To Login?")
                }
            }
        }
    }
    
    func getUser() {
        MainService.shared.getUser { [weak self] (result) in
            switch result {
            case .failure(let err):
                self?.presenter?.failGetUser(title: "Oops", message: err.localizedDescription + ", Try Again?")
            case .success(let res):
                if let data = res.data, res.success {
                    self?.presenter?.didGetUser(data: data)
                } else {
                    self?.presenter?.failGetUser(title: "Oops", message: res.message + ", Try Again?")
                }
            }
        }
    }
}
