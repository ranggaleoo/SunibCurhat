//
//  ChatsPresenter.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 24/02/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import Foundation

class ChatsPresenter: ChatsViewToPresenter {
    weak var view: ChatsPresenterToView?
    var interactor: ChatsPresenterToInteractor?
    var router: ChatsPresenterToRouter?
    
    func didLoad() {
        view?.setupViews()
        SocketService.shared.delegate = self
    }
    
    func numberOfRowsInSection() -> Int {
        return 5
    }
    
    func cellForRowAt() -> String {
        return "OK"
    }
}

extension ChatsPresenter: ChatsInteractorToPresenter {
}

extension ChatsPresenter: SocketDelegate {
    func didGetUsers(users: [Any]?) {
        debugLog(users)
    }
}
