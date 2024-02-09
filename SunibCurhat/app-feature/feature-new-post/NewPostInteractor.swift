// 
//  NewPostInteractor.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 09/02/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import Foundation

class NewPostInteractor: NewPostPresenterToInteractor {
    weak var presenter: NewPostInteractorToPresenter?
    
    func newPost(user_id: String, name: String, text_content: String) {
        NewPostService.shared.newPost(user_id: user_id, name: name, text_content: text_content) { [weak self] (result) in
            switch result {
            case .success(let res):
                if res.success {
                    self?.presenter?.didPosted()
                } else {
                    self?.presenter?.failPost(message: res.message)
                }
            case .failure(let err):
                self?.presenter?.failPost(message: err.localizedDescription)
            }
        }
    }
}
