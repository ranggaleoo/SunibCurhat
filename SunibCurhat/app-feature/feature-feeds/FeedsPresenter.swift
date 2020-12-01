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
    
    func didLoad() {
        view?.setupViews()
        interactor?.getTimelines()
    }
    
    func numberOfRowsInSection() -> Int {
        return timelines.count
    }
    
    func cellForRowAt(indexPath: IndexPath) -> TimelineItems {
        return timelines[indexPath.row]
    }
    
    func didSelectRowAt(indexPath: IndexPath) {
        
    }
    
    func scrollViewDidScroll() {
        
    }
}

extension FeedsPresenter: FeedsInteractorToPresenter {
    func didGetTimelines(timelines: [TimelineItems]) {
        self.timelines = timelines
        view?.reloadTableView()
    }
    
    func failedGetTimelines(title: String, message: String) {
        view?.showAlert(title: title, message: message)
    }
}
