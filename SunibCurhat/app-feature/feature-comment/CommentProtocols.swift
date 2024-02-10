// 
//  CommentProtocols.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 10/02/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import UIKit

// MARK: View -
protocol CommentPresenterToView: AnyObject {
    var presenter: CommentViewToPresenter? { get set }
    
    func setupViews()
    func updateUI(data: TimelineItems)
    func showFailMessaggeGetTimeline(title: String, message: String)
    func showFailMessageGetComment(title: String, message: String)
    func startLoader()
    func stopLoader()
    func reloadComments()
}

// MARK: Interactor -
protocol CommentPresenterToInteractor: AnyObject {
    var presenter: CommentInteractorToPresenter?  { get set }
    
    func getTimelineById(timeline_id: Int)
    func getCommentsByTimelineId(timeline_id: Int, page: Int, itemPerPage: Int)
}

// MARK: Router -
protocol CommentPresenterToRouter: AnyObject {
    static func createCommentModule(timeline_id: Int) -> UIViewController
    
    func navigateToMain(from: CommentPresenterToView?)
}

// MARK: Presenter -
protocol CommentViewToPresenter: AnyObject {
    var view: CommentPresenterToView? {get set}
    var interactor: CommentPresenterToInteractor? {get set}
    var router: CommentPresenterToRouter? {get set}
    var timeline_id: Int? {get set}
    
    func didLoad()
    func didRequestTimeline()
    func didRequestComments()
    func numberOfRowsInSection() -> Int
    func cellForRowAt(index: Int) -> CommentItems
}

protocol CommentInteractorToPresenter: AnyObject {
    func didGetTimeline(data: TimelineItems)
    func didGetComment(data: CommentResponse)
    func failGetTimeline(message: String)
    func failGetComments(message: String)
}
