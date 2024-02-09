//
//  NewPostPresenter.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 09/02/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import Foundation

class NewPostPresenter: NewPostViewToPresenter {
    weak var view: NewPostPresenterToView?
    var interactor: NewPostPresenterToInteractor?
    var router: NewPostPresenterToRouter?
    
    private let user: User? = UDHelpers.shared.getObject(type: User.self, forKey: .user)
    private var textContent: String? = nil
    
    func didLoad() {
        view?.setupViews()
    }
    
    func set(textContent: String) {
        self.textContent = textContent
    }
    
    func didClickPost() {
        view?.startLoader()
        interactor?.newPost(
            user_id: user?.user_id ?? "",
            name: user?.name ?? "",
            text_content: textContent ?? ""
        )
    }
}

extension NewPostPresenter: NewPostInteractorToPresenter {
    func didPosted() {
        view?.stopLoader()
        router?.navigateToMain(from: view)
    }
    
    func failPost(message: String) {
        view?.stopLoader()
        view?.showFailMessagePost(message: message)
    }
}
