// 
//  SplashProtocols.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 28/02/21.
//  Copyright © 2021 Rangga Leo. All rights reserved.
//

import UIKit


// MARK: View -
protocol SplashPresenterToView: class {
    var presenter: SplashViewToPresenter? { get set }
    
    func setupViews()
    func startLoader()
    func stopLoader()
    func showAlertConfirm(title: String, message: String, okCompletion: (() -> Void)?, cancelCompletion: (() -> Void)?)
}

// MARK: Interactor -
protocol SplashPresenterToInteractor: class {
    var presenter: SplashInteractorToPresenter?  { get set }
    
    func getEndpoint()
}


// MARK: Router -
protocol SplashPresenterToRouter: class {
    static func createSplashModule() -> UIViewController
    func navigateToMain(from: SplashPresenterToView?)
}

// MARK: Presenter -
protocol SplashViewToPresenter: class {
    var view: SplashPresenterToView? {get set}
    var interactor: SplashPresenterToInteractor? {get set}
    var router: SplashPresenterToRouter? {get set}
    
    func didLoad()
    func initialSettings()
}

protocol SplashInteractorToPresenter: class {
    func didGetEndpoint(data: EndpointResponse)
    func failGetEndpoint(title: String, message: String)
}
