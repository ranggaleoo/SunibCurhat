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
}
