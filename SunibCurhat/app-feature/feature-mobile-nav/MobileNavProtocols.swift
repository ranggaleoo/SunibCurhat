// 
//  MobileNavProtocols.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 05/03/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import UIKit

// MARK: View -
protocol MobileNavPresenterToView: AnyObject {
    var presenter: MobileNavViewToPresenter? { get set }
    
    func setupViews()
    func showConfirmation(title: String, message: String)
    func showMessage(title: String, message: String)
    func startLoader()
    func stopLoader()
}

// MARK: Interactor -
protocol MobileNavPresenterToInteractor: AnyObject {
    var presenter: MobileNavInteractorToPresenter?  { get set }
    
    func hitActionApi(path: String)
}

// MARK: Router -
protocol MobileNavPresenterToRouter: AnyObject {
    static func createMobileNavModule(data: [MobileNavigationPageSection]?) -> UIViewController
    func navigateToMobileNav(from: MobileNavPresenterToView?, data: [MobileNavigationPageSection]?)
    func navigateToWebView(from: MobileNavPresenterToView?, url: URL?)
    func navigateToExternalURL(url: URL?)
}

// MARK: Presenter -
protocol MobileNavViewToPresenter: AnyObject {
    var view: MobileNavPresenterToView? {get set}
    var interactor: MobileNavPresenterToInteractor? {get set}
    var router: MobileNavPresenterToRouter? {get set}
    
    init(sections: [MobileNavigationPageSection]?)
    func didLoad()
    func didConfirm()
    func didSwitch(isOn: Bool, indexPath: IndexPath)
    func numberOfSections() -> Int?
    func numberOfRowsInSection(section: Int) -> Int?
    func cellForRowAt(indexPath: IndexPath) -> MobileNavigationPageSection?
    func titleForHeaderInSection(section: Int) -> String?
    func didSelectRowAt(indexPath: IndexPath)
}

protocol MobileNavInteractorToPresenter: AnyObject {
    func didHitActionApi()
    func failHitActionApi(message: String)
}
