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
    
    func getTimelines(user_id: String, page: String, itemPerPage: String) {
        FeedsService.shared.getTimelines(user_id: user_id, page: page, itemPerPage: itemPerPage) { (result) in
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
    
    func likeTimeline(user_id: String, timelineID: Int) {
        FeedsService.shared.likeTimeline(user_id: user_id, timeline_id: timelineID) { (result) in
            switch result {
            case .failure(let err):
                debugLog(err.localizedDescription)
            case .success(let res):
                if res.success {
                    self.presenter?.didLikeTimeline(id: timelineID)
                }
            }
        }
    }
    
    func unlikeTimeline(user_id: String, timelineID: Int) {
        FeedsService.shared.unlikeTimeline(user_id: user_id, timeline_id: timelineID) { (result) in
            switch result {
            case .failure(let err):
                debugLog(err.localizedDescription)
            case .success(let res):
                if res.success {
                    self.presenter?.didUnlikeTimeline(id: timelineID)
                }
            }
        }
    }
    
    func shareTimeline(user_id: String, timelineID: Int) {
        FeedsService.shared.shareTimeline(user_id: user_id, timeline_id: timelineID) { (result) in
            switch result {
            case .failure(_): break
            case .success(_): break
            }
        }
    }
    
    func deleteTimelime(user_id: String, timelineID: Int) {
        FeedsService.shared.deleteTimeline(user_id: user_id, timeline_id: timelineID) { (result) in
            switch result {
            case .failure(let err):
                debugLog(err.localizedDescription)
            case .success(let res):
                debugLog(res)
            }
        }
    }
    
    func signOut() {
        MainService.shared.logout { [weak self] (result) in
            switch result {
            case .failure(let err):
                debugLog(err.localizedDescription)
            case .success(let res):
                if res.success {
                    self?.presenter?.didSignOut()
                }
            }
        }
    }
    
    func createConversationRoom(conversation: Conversation) {
        SocketService.shared.emit(.req_create_conversation, conversation, completion: { [weak self] result in
            switch result {
            case .success():
                self?.presenter?.didCreateConversationRoom(conversation: conversation)
            case .failure(let err):
                self?.presenter?.failCreateConversationRoom(title: "Oops", message: err.localizedDescription)
            }
        })
    }
}
