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
}
