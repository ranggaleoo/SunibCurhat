// 
//  NewPostProtocols.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 09/02/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import UIKit

// MARK: View -
protocol NewPostPresenterToView: AnyObject {
    var presenter: NewPostViewToPresenter? { get set }
    
    func setupViews()
    func startLoader()
    func stopLoader()
    func showFailMessagePost(message: String)
}

// MARK: Interactor -
protocol NewPostPresenterToInteractor: AnyObject {
    var presenter: NewPostInteractorToPresenter?  { get set }
    
    func newPost(user_id: String, name: String, text_content: String)
}

// MARK: Router -
protocol NewPostPresenterToRouter: AnyObject {
    static func createNewPostModule() -> UIViewController
    func navigateToMain(from: NewPostPresenterToView?)
}

// MARK: Presenter -
protocol NewPostViewToPresenter: AnyObject {
    var view: NewPostPresenterToView? {get set}
    var interactor: NewPostPresenterToInteractor? {get set}
    var router: NewPostPresenterToRouter? {get set}
    
    func didLoad()
    func set(textContent: String)
    func didClickPost()
}

protocol NewPostInteractorToPresenter: AnyObject {
    func didPosted()
    func failPost(message: String)
}
