// 
//  FeedsInteractor.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 27/11/20.
//  Copyright © 2020 Rangga Leo. All rights reserved.
//

import Foundation

class FeedsInteractor: FeedsPresenterToInteractor {
    weak var presenter: FeedsInteractorToPresenter?
    
    func getTimelines(page: Int) {
        TimelineService.shared.getTimeline(page: page) { (result) in
            switch result {
            case .failure(let err):
                self.presenter?.failedGetTimelines(title: "Error", message: err.localizedDescription)
            case .success(let res):
                if res.success, let data = res.data {
                    self.presenter?.didGetTimelines(timelines: data.timelines, next_page: data.next_page)
                }
            }
        }
    }
    
    func likeTimeline(timelineID: Int) {
        TimelineService.shared.likeTimeline(timeline_id: timelineID) { (result) in
            switch result {
            case .failure(let err):
                print(err.localizedDescription)
            case .success(let res):
                if res.success {
                    self.presenter?.didLikeTimeline(id: timelineID)
                }
            }
        }
    }
    
    func unlikeTimeline(timelineID: Int) {
        TimelineService.shared.unlikeTimeline(timeline_id: timelineID) { (result) in
            switch result {
            case .failure(let err):
                print(err.localizedDescription)
            case .success(let res):
                if res.success {
                    self.presenter?.didUnlikeTimeline(id: timelineID)
                }
            }
        }
    }
    
    func shareTimeline(timelineID: Int) {
        TimelineService.shared.shareTimeline(timeline_id: timelineID) { (result) in
            switch result {
            case .failure(_): break
            case .success(_): break
            }
        }
    }
    
    func deleteTimelime(timelineID: Int) {
        TimelineService.shared.deleteTimeline(timeline_id: timelineID) { (result) in
            switch result {
            case .failure(let err):
                print(err.localizedDescription)
            case .success(let res):
                print(res)
            }
        }
    }
}
