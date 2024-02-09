// 
//  FeedsProtocols.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 27/11/20.
//  Copyright © 2020 Rangga Leo. All rights reserved.
//

import UIKit

// MARK: View -
protocol FeedsPresenterToView: class {
    var presenter: FeedsViewToPresenter? { get set }
    
    func setupViews()
    func showAlert(title: String, message: String)
    func reloadTableView()
    func finishRefershControl()
    func updateLikeCell(indexPath: IndexPath)
    func showShareController(items: [Any], completion: @escaping (() -> Void))
    func removeCell(index: [IndexPath])
}

// MARK: Interactor -
protocol FeedsPresenterToInteractor: class {
    var presenter: FeedsInteractorToPresenter?  { get set }
    
    func getTimelines(user_id: String, page: String, itemPerPage: String)
    func likeTimeline(user_id: String, timelineID: Int)
    func unlikeTimeline(user_id: String, timelineID: Int)
    func shareTimeline(user_id: String, timelineID: Int)
    func deleteTimelime(timelineID: Int)
}


// MARK: Router -
protocol FeedsPresenterToRouter: class {
    static func createFeedsModule() -> UIViewController
    func navigateToNewPost(from: FeedsPresenterToView?)
    func navigateToComment(timeline: TimelineItems, view: FeedsPresenterToView?)
    func navigateToReport(timeline: TimelineItems, view: FeedsPresenterToView?)
}

// MARK: Presenter -
protocol FeedsViewToPresenter: class {
    var view: FeedsPresenterToView? {get set}
    var interactor: FeedsPresenterToInteractor? {get set}
    var router: FeedsPresenterToRouter? {get set}
    
    func didLoad()
    func didClickNewPost()
    func requestGetTimeline(resetData: Bool)
    func numberOfRowsInSection() -> Int
    func cellForRowAt(indexPath: IndexPath) -> TimelineItems
    func didSelectRowAt(indexPath: IndexPath)
    func scrollViewDidScroll()
    func getTimelineItem(indexPath: IndexPath) -> TimelineItems
    func requestDeleteTimeline(indexPath: IndexPath)
    func requestReport(indexPath: IndexPath)
    func requestComment(indexPath: IndexPath)
    func requestLike(indexPath: IndexPath, isLiked: Bool)
    func requestShare(indexPath: IndexPath)
}

protocol FeedsInteractorToPresenter: class {
    
    func didGetTimelines(timelines: [TimelineItems], next_page: Int)
    func failedGetTimelines(title: String, message: String)
    func didLikeTimeline(id: Int)
    func didUnlikeTimeline(id: Int)
}
