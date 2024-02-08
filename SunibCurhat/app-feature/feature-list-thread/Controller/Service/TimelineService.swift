//
//  TimelineService.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 17/08/19.
//  Copyright © 2019 Rangga Leo. All rights reserved.
//

import Foundation
import UIKit

class TimelineService {
    
    static let shared: TimelineService = TimelineService()
    
    @available(*, deprecated, renamed: "getTimelines", message: "Use FeedsService.shared.getTimelines instead for improved performance and compatibility.")
    func getTimeline(page: Int, completion: @escaping (Result<MainResponse<TimelineResponse>, Error>) -> Void) {
        var param: [String: Any] = [:]
        param["page"]       = page
        param["limit"]      = 5
        param["device_id"]  = RepoMemory.device_id
        
        if let token = RepoMemory.token {
            param["X_SIGNATURE_API"] = token
        }
        
        let url = URLConst.api_url + "/timeline/"
        HTTPRequest.shared.headers[.contentType] = "application/json"
        HTTPRequest.shared.headers[.referer] = URLConst.server
        HTTPRequest.shared.connect(url: url, params: param, model: MainResponse<TimelineResponse>.self) { (result) in
            debugLog(result)
            completion(result)
        }
    }
    
    func likeTimeline(timeline_id: Int, completion: @escaping (Result<MainResponse<String>, Error>) -> Void) {
        var param: [String: Any] = [:]
        param["device_id"] = RepoMemory.device_id
        param["timeline_id"] = timeline_id
        
        if let token = RepoMemory.token {
            param["X_SIGNATURE_API"] = token
        }
        
        let url = URLConst.api_url + "/likeTimeline"
        HTTPRequest.shared.headers[.contentType] = "application/json; charset=utf-8"
        HTTPRequest.shared.headers[.referer] = URLConst.server
        HTTPRequest.shared.connect(url: url, params: param, model: MainResponse<String>.self) { (result) in
            completion(result)
        }
    }
    
    func unlikeTimeline(timeline_id: Int, completion: @escaping (Result<MainResponse<String>, Error>) -> Void) {
        var param: [String: Any] = [:]
        param["device_id"] = RepoMemory.device_id
        param["timeline_id"] = timeline_id
        
        if let token = RepoMemory.token {
        param["X_SIGNATURE_API"] = token
        }
        
        let url = URLConst.api_url + "/unlikeTimeline"
        HTTPRequest.shared.headers[.contentType] = "application/json; charset=utf-8"
        HTTPRequest.shared.headers[.referer] = URLConst.server
        HTTPRequest.shared.connect(url: url, params: param, model: MainResponse<String>.self) { (result) in
            completion(result)
        }
    }
    
    func shareTimeline(timeline_id: Int, completion: @escaping (Result<MainResponse<String>, Error>) -> Void) {
        var param: [String: Any] = [:]
        param["device_id"] = RepoMemory.device_id
        param["timeline_id"] = timeline_id
        
        if let token = RepoMemory.token {
            param["X_SIGNATURE_API"] = token
        }
        
        let url = URLConst.api_url + "/shareTimeline"
        HTTPRequest.shared.headers[.contentType] = "application/json; charset=utf-8"
        HTTPRequest.shared.headers[.referer] = URLConst.server
        HTTPRequest.shared.connect(url: url, params: param, model: MainResponse<String>.self) { (result) in
            completion(result)
        }
    }
    
    func deleteTimeline(timeline_id: Int, completion: @escaping (Result<MainResponse<String>, Error>) -> Void) {
        let url = URLConst.api_url + "/deleteTimeline"
        var param: [String: Any] = [:]
        param["timeline_id"] = timeline_id
        
        if let token = RepoMemory.token {
            param["X_SIGNATURE_API"] = token
        }
        HTTPRequest.shared.headers[.contentType] = "application/json; charset=utf-8"
        HTTPRequest.shared.headers[.referer] = URLConst.server
        HTTPRequest.shared.connect(url: url, params: param, model: MainResponse<String>.self) { (result) in
            completion(result)
        }
    }
}
