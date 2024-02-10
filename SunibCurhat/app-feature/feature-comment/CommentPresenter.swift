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
    private var page: Int = 1
    private let itemPerPage: Int = 10
    private var comments: [CommentItems] = []
    
    func didLoad() {
        view?.setupViews()
        view?.startLoader()
        guard let timeline_id = timeline_id else {
            fatalError("undefined timeline_id")
        }
        interactor?.getTimelineById(timeline_id: timeline_id)
    }
    
    func didRequestTimeline() {
        //
    }
    
    func didRequestComments() {
        //
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
    
    func failGetTimeline(message: String) {
        view?.stopLoader()
        view?.showFailMessaggeGetTimeline(title: "Oops", message: message)
    }
    
    func failGetComments(message: String) {
        view?.stopLoader()
        view?.showFailMessageGetComment(title: "Oops", message: message)
    }
}
