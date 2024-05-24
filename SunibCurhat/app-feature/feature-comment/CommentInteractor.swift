// 
//  CommentInteractor.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 10/02/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import Foundation

class CommentInteractor: CommentPresenterToInteractor {
    weak var presenter: CommentInteractorToPresenter?
    
    func getTimelineById(timeline_id: Int) {
        FeedsService.shared.getTimelineById(timeline_id: timeline_id) { [weak self] (result) in
            switch result {
            case .success(let res):
                if res.success, let data = res.data {
                    self?.presenter?.didGetTimeline(data: data)
                } else {
                    self?.presenter?.failGetTimeline(message: res.message)
                }
            case .failure(let err):
                self?.presenter?.failGetTimeline(message: err.localizedDescription)
            }
        }
    }
    
    func getCommentsByTimelineId(timeline_id: Int, page: Int, itemPerPage: Int) {
        CommentService.shared.getCommentsByTimelineId(timeline_id: timeline_id, page: page, itemPerPage: itemPerPage) { [weak self] (result) in
            switch result {
            case .success(let res):
                if res.success, let data = res.data {
                    self?.presenter?.didGetComment(data: data)
                } else {
                    self?.presenter?.failGetComments(message: res.message)
                }
            case .failure(let err):
                self?.presenter?.failGetComments(message: err.localizedDescription)
            }
        }
    }
    
    func addNewComment(timeline_id: Int, user_id: String, name: String, text_content: String) {
        CommentService.shared.addNewComment(timeline_id: timeline_id, user_id: user_id, name: name, text_content: text_content) { [weak self] (result) in
            switch result {
            case .success(let res):
                if res.success, let data = res.data {
                    self?.presenter?.didSendComment(comment: data)
                } else {
                    self?.presenter?.failSendComment(message: res.message)
                }
            case .failure(let err):
                self?.presenter?.failSendComment(message: err.localizedDescription)
            }
        }
    }
}
