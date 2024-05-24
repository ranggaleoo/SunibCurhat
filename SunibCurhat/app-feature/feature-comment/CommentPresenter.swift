//
//  CommentPresenter.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 10/02/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import Foundation

class CommentPresenter: CommentViewToPresenter {
    weak var view: CommentPresenterToView?
    var interactor: CommentPresenterToInteractor?
    var router: CommentPresenterToRouter?
    var timeline_id: Int? = nil
    private var user: User? = UDHelpers.shared.getObject(type: User.self, forKey: .user)
    private var page: Int = 1
    private let itemPerPage: Int = 10
    private var comments: [CommentItems] = []
    private var text_content: String? = nil
    
    func didLoad() {
        view?.setupViews()
        view?.startLoader()
        guard let timeline_id = timeline_id else {
            fatalError("undefined timeline_id")
        }
        interactor?.getTimelineById(timeline_id: timeline_id)
    }
    
    func set(text_content: String) {
        self.text_content = text_content
    }
    
    func didRequestTimeline() {
        //
    }
    
    func didRequestComments() {
        //
    }
    
    func didClickNewComment() {
        view?.startLoader()
        if let t_id = timeline_id,
           let user_id = user?.user_id,
           let user_name = user?.name,
           let text = text_content {
            interactor?.addNewComment(
                timeline_id: t_id,
                user_id: user_id,
                name: user_name,
                text_content: text
            )
        }
    }
    
    func numberOfRowsInSection() -> Int {
        return comments.count
    }
    
    func cellForRowAt(index: Int) -> CommentItems {
        return comments[index]
    }
}

extension CommentPresenter: CommentInteractorToPresenter {
    func didGetTimeline(data: TimelineItems) {
        view?.updateUI(data: data)
        guard let timeline_id = timeline_id else {
            fatalError("undefined timeline_id")
        }
        interactor?.getCommentsByTimelineId(timeline_id: timeline_id, page: page, itemPerPage: itemPerPage)
    }
    
    func didGetComment(data: CommentResponse) {
        page = data.next_page
        comments.append(data.comments)
        view?.stopLoader()
        view?.reloadComments()
    }
    
    func didSendComment(comment: CommentItems) {
        comments.insert(comment, at: 0)
        view?.stopLoader()
        view?.reloadComments()
    }
    
    func failGetTimeline(message: String) {
        view?.stopLoader()
        view?.showFailMessage(title: "Oops", message: message)
    }
    
    func failGetComments(message: String) {
        view?.stopLoader()
//        view?.showFailMessage(title: "Oops", message: message)
    }
    
    func failSendComment(message: String) {
        view?.stopLoader()
        view?.showFailMessage(title: "Oops", message: message)
    }
}
