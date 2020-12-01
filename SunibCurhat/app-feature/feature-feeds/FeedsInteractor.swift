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
    
    func getTimelines() {
        TimelineService.shared.getTimeline(page: 1) { (result) in
            switch result {
            case .failure(let err):
                self.presenter?.failedGetTimelines(title: "Error", message: err.localizedDescription)
            case .success(let res):
                if res.success, let data = res.data {
                    self.presenter?.didGetTimelines(timelines: data.timelines)
                }
            }
        }
    }
}
