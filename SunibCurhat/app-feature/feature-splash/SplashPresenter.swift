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
    
    private var timer: Timer?
    private var counter: Int = 0
    
    func didLoad() {
        view?.setupViews()
        view?.startLoader()
        interactor?.getEndpoint()
    }
}

extension SplashPresenter: SplashInteractorToPresenter {
    func didGetEndpoint(data: EndpointResponse) {
        URLConst.server = data.endpoint
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
}
