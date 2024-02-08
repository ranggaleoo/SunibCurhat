//
//  FeedsPresenter.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 27/11/20.
//  Copyright © 2020 Rangga Leo. All rights reserved.
//

import Foundation

class FeedsPresenter: FeedsViewToPresenter {
    weak var view: FeedsPresenterToView?
    var interactor: FeedsPresenterToInteractor?
    var router: FeedsPresenterToRouter?
    
    private var timelines: [TimelineItems] = []
    private var next_page: Int = 1
    private var getTimelineMore: Bool = false
    
    func didLoad() {
        view?.setupViews()
        requestGetTimeline(resetData: false)
    }
    
    func requestGetTimeline(resetData: Bool) {
        guard !getTimelineMore else {
            return
        }
        getTimelineMore = true
        
        if resetData {
            next_page = 1
            timelines.removeAll()
            view?.reloadTableView()
        }
        
        if next_page == 999 {
            self.getTimelineMore = false
            return
        }
        
        if let user = UDHelpers.shared.getObject(type: User.self, forKey: .user) {
            interactor?.getTimelines(user_id: user.user_id, page: "\(next_page)", itemPerPage: "10")
        }
    }
    
    func numberOfRowsInSection() -> Int {
        return timelines.count
    }
    
    func cellForRowAt(indexPath: IndexPath) -> TimelineItems {
        return timelines[indexPath.row]
    }
    
    func didSelectRowAt(indexPath: IndexPath) {
        let timeline = timelines[indexPath.row]
        router?.navigateToComment(timeline: timeline, view: view)
    }
    
    func scrollViewDidScroll() {
        if !getTimelineMore {
            requestGetTimeline(resetData: false)
        }
    }
    
    func getTimelineItem(indexPath: IndexPath) -> TimelineItems {
        return timelines[indexPath.row]
    }
    
    func requestDeleteTimeline(indexPath: IndexPath) {
        let timelineId = timelines[indexPath.row].timeline_id
        timelines.remove(at: indexPath.row)
        view?.removeCell(index: [indexPath])
        interactor?.deleteTimelime(timelineID: timelineId)
    }
    
    func requestReport(indexPath: IndexPath) {
        let timeline = timelines[indexPath.row]
        router?.navigateToReport(timeline: timeline, view: view)
    }

    func requestComment(indexPath: IndexPath) {
        let timeline = timelines[indexPath.row]
        router?.navigateToComment(timeline: timeline, view: view)
    }
    
    func requestLike(indexPath: IndexPath, isLiked: Bool) {
        let timelineId = timelines[indexPath.row].timeline_id
        if isLiked {
            interactor?.unlikeTimeline(timelineID: timelineId)
        } else {
            interactor?.likeTimeline(timelineID: timelineId)
        }
    }
    
    func requestShare(indexPath: IndexPath) {
        let timeline_id = timelines[indexPath.row].timeline_id
        let shareText = timelines[indexPath.row].text_content + " - " + timelines[indexPath.row].name
        view?.showShareController(items: [shareText], completion: {
            self.interactor?.shareTimeline(timelineID: timeline_id)
        })
    }
}

extension FeedsPresenter: FeedsInteractorToPresenter {
    func didGetTimelines(timelines: [TimelineItems], next_page: Int) {
        getTimelineMore = false
        self.next_page = next_page
        self.timelines.append(timelines)
        view?.reloadTableView()
        view?.finishRefershControl()
    }
    
    func failedGetTimelines(title: String, message: String) {
        getTimelineMore = false
        view?.showAlert(title: title, message: message)
    }
    
    func didLikeTimeline(id: Int) {
        if let timeline = timelines.filter({$0.timeline_id == id}).first {
            if let index = timelines.firstIndex(of: timeline) {
                let indexPath = IndexPath(row: index, section: 0)
                view?.updateLikeCell(indexPath: indexPath)
            }
        }
    }
    
    func didUnlikeTimeline(id: Int) {
        if let timeline = timelines.filter({$0.timeline_id == id}).first {
            if let index = timelines.firstIndex(of: timeline) {
                let indexPath = IndexPath(row: index, section: 0)
                view?.updateLikeCell(indexPath: indexPath)
            }
        }
    }
}
