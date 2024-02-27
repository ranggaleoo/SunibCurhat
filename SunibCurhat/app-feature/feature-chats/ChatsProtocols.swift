// 
//  ChatsProtocols.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 24/02/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import UIKit

// MARK: View -
protocol ChatsPresenterToView: AnyObject {
    var presenter: ChatsViewToPresenter? { get set }
    
    func setupViews()
}

// MARK: Interactor -
protocol ChatsPresenterToInteractor: AnyObject {
    var presenter: ChatsInteractorToPresenter?  { get set }
}

// MARK: Router -
protocol ChatsPresenterToRouter: AnyObject {
    static func createChatsModule() -> UIViewController
}

// MARK: Presenter -
protocol ChatsViewToPresenter: AnyObject {
    var view: ChatsPresenterToView? {get set}
    var interactor: ChatsPresenterToInteractor? {get set}
    var router: ChatsPresenterToRouter? {get set}
    
    func didLoad()
    func numberOfRowsInSection() -> Int
    func cellForRowAt() -> String
}

protocol ChatsInteractorToPresenter: AnyObject {
}
