// 
//  ProfileProtocols.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 05/03/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import UIKit

// MARK: View -
protocol ProfilePresenterToView: AnyObject {
    var presenter: ProfileViewToPresenter? { get set }
    
    func setupViews()
    func showConfirmation(title: String, message: String)
    func startLoader()
    func stopLoader()
    func showMessage(title: String, message: String)
}

// MARK: Interactor -
protocol ProfilePresenterToInteractor: AnyObject {
    var presenter: ProfileInteractorToPresenter?  { get set }
    
    func hitActionApi(path: String)
}

// MARK: Router -
protocol ProfilePresenterToRouter: AnyObject {
    static func createProfileModule() -> UIViewController
    func navigateToMobileNav(from: ProfilePresenterToView?, data: [MobileNavigationPageSection]?)
    func navigateToWebView(from: ProfilePresenterToView?, url: URL?)
    func navigateToExternalURL(url: URL?)
    func navigateToLogin(from: ProfilePresenterToView?)
}

// MARK: Presenter -
protocol ProfileViewToPresenter: AnyObject {
    var view: ProfilePresenterToView? {get set}
    var interactor: ProfilePresenterToInteractor? {get set}
    var router: ProfilePresenterToRouter? {get set}
    
    func didLoad()
    func didConfirm()
    func didSwitch(isOn: Bool, indexPath: IndexPath)
    func numberOfSections() -> Int?
    func numberOfRowsInSection(section: Int) -> Int?
    func cellForRowAt(indexPath: IndexPath) -> MobileNavigationPageSection?
    func titleForHeaderInSection(section: Int) -> String?
    func didSelectRowAt(indexPath: IndexPath)
}

protocol ProfileInteractorToPresenter: AnyObject {
    func didHitActionApi()
    func failHitActionApi(message: String)
}
