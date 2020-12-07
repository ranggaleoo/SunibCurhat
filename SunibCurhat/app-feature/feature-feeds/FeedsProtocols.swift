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
}

// MARK: Interactor -
protocol FeedsPresenterToInteractor: class {
    var presenter: FeedsInteractorToPresenter?  { get set }
    
    func getTimelines(page: Int)
    func likeTimeline(timelineID: Int)
    func unlikeTimeline(timelineID: Int)
}


// MARK: Router -
protocol FeedsPresenterToRouter: class {
    static func createFeedsModule() -> UIViewController
    func navigateToComment(timeline: TimelineItems, view: FeedsPresenterToView?)
}

// MARK: Presenter -
protocol FeedsViewToPresenter: class {
    var view: FeedsPresenterToView? {get set}
    var interactor: FeedsPresenterToInteractor? {get set}
    var router: FeedsPresenterToRouter? {get set}
    
    func didLoad()
    func requestGetTimeline(resetData: Bool)
    func numberOfRowsInSection() -> Int
    func cellForRowAt(indexPath: IndexPath) -> TimelineItems
    func didSelectRowAt(indexPath: IndexPath)
    func scrollViewDidScroll()
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
