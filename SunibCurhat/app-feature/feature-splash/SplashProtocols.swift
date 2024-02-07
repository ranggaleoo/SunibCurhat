// 
//  SplashProtocols.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 28/02/21.
//  Copyright © 2021 Rangga Leo. All rights reserved.
//

import UIKit


// MARK: View -
protocol SplashPresenterToView: AnyObject {
    var presenter: SplashViewToPresenter? { get set }
    
    func setupViews()
    func startLoader()
    func stopLoader()
    func showAlertConfirm(title: String, message: String, okCompletion: (() -> Void)?, cancelCompletion: (() -> Void)?)
}

// MARK: Interactor -
protocol SplashPresenterToInteractor: AnyObject {
    var presenter: SplashInteractorToPresenter?  { get set }
    
    func getEndpoint()
    func getPreferences()
    func refreshToken()
    func getUser()
}


// MARK: Router -
protocol SplashPresenterToRouter: AnyObject {
    static func createSplashModule() -> UIViewController
    func navigateToMain(from: SplashPresenterToView?)
    func navigateToLogin(from: SplashPresenterToView?)
}

// MARK: Presenter -
protocol SplashViewToPresenter: AnyObject {
    var view: SplashPresenterToView? {get set}
    var interactor: SplashPresenterToInteractor? {get set}
    var router: SplashPresenterToRouter? {get set}
    
    func didLoad()
    func initialSettings()
}

protocol SplashInteractorToPresenter: AnyObject {
    func didGetEndpoint(data: EndpointResponse)
    func failGetEndpoint(title: String, message: String)
    func didGetPreferences(data: Preferences)
    func failGetPreferences(title: String, message: String)
    func didGetToken(data: RefreshTokenData)
    func failGetToken(title: String, message: String)
    func didGetUser(data: User)
    func failGetUser(title: String, message: String)
}
