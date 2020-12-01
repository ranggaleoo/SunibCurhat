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
}

// MARK: Interactor -
protocol FeedsPresenterToInteractor: class {
    var presenter: FeedsInteractorToPresenter?  { get set }
    
    func getTimelines()
}


// MARK: Router -
protocol FeedsPresenterToRouter: class {
    static func createFeedsModule() -> UIViewController
}

// MARK: Presenter -
protocol FeedsViewToPresenter: class {
    var view: FeedsPresenterToView? {get set}
    var interactor: FeedsPresenterToInteractor? {get set}
    var router: FeedsPresenterToRouter? {get set}
    
    func didLoad()
    func numberOfRowsInSection() -> Int
    func cellForRowAt(indexPath: IndexPath) -> TimelineItems
    func didSelectRowAt(indexPath: IndexPath)
    func scrollViewDidScroll()
}

protocol FeedsInteractorToPresenter: class {
    
    func didGetTimelines(timelines: [TimelineItems])
    func failedGetTimelines(title: String, message: String)
}
