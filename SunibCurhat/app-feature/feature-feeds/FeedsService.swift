//
//  FeedsService.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 08/02/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import Foundation

class FeedsService {
    static let shared: FeedsService = FeedsService()
    
    func getTimelines(user_id: String, page: String, itemPerPage: String, completion: @escaping (Result<MainResponse<TimelineResponse>, Error>) -> Void) {
        let base_url = URLConst.server + URLConst.path_v1
        let url_request = "\(base_url)/timeline/\(user_id)/\(page)/\(itemPerPage)"
        let access_token = UDHelpers.shared.getString(key: .access_token)
        let auth = "Bearer \(access_token)"
        
        HTTPRequest.shared.headers[.xplatform] = "IOS"
        HTTPRequest.shared.headers[.authorization] = auth
        HTTPRequest.shared.connect(url: url_request, params: nil, model: MainResponse<TimelineResponse>.self) { (result) in
            completion(result)
        }
    }
    
    func getTimelineById(timeline_id: Int, completion: @escaping (Result<MainResponse<TimelineItems>, Error>) -> Void) {
        let base_url = URLConst.server + URLConst.path_v1
        let url_request = "\(base_url)/timeline/\(timeline_id)"
        let access_token = UDHelpers.shared.getString(key: .access_token)
        let auth = "Bearer \(access_token)"
        
        HTTPRequest.shared.headers[.xplatform] = "IOS"
        HTTPRequest.shared.headers[.authorization] = auth
        HTTPRequest.shared.connect(url: url_request, params: nil, model: MainResponse<TimelineItems>.self) { (result) in
            completion(result)
        }
    }
    
    func likeTimeline(user_id: String, timeline_id: Int, completion: @escaping (Result<MainResponse<String>, Error>) -> Void) {
        let base_url = URLConst.server + URLConst.path_v1
        let url_request = "\(base_url)/timeline/like/"
        let access_token = UDHelpers.shared.getString(key: .access_token)
        let auth = "Bearer \(access_token)"
        
        var params: [String: Any] = [:]
        params["user_id"] = user_id
        params["timeline_id"] = timeline_id
        
        HTTPRequest.shared.headers[.xplatform] = "IOS"
        HTTPRequest.shared.headers[.authorization] = auth
        HTTPRequest.shared.connect(url: url_request, params: params, model: MainResponse<String>.self) { (result) in
            completion(result)
        }
    }
    
    func unlikeTimeline(user_id: String, timeline_id: Int, completion: @escaping (Result<MainResponse<String>, Error>) -> Void) {
        let base_url = URLConst.server + URLConst.path_v1
        let url_request = "\(base_url)/timeline/unlike/"
        let access_token = UDHelpers.shared.getString(key: .access_token)
        let auth = "Bearer \(access_token)"
        
        var params: [String: Any] = [:]
        params["user_id"] = user_id
        params["timeline_id"] = timeline_id
        
        HTTPRequest.shared.headers[.xplatform] = "IOS"
        HTTPRequest.shared.headers[.authorization] = auth
        HTTPRequest.shared.connect(url: url_request, params: params, model: MainResponse<String>.self) { (result) in
            completion(result)
        }
    }
    
    func shareTimeline(user_id: String, timeline_id: Int, completion: @escaping (Result<MainResponse<String>, Error>) -> Void) {
        let base_url = URLConst.server + URLConst.path_v1
        let url_request = "\(base_url)/timeline/share/"
        let access_token = UDHelpers.shared.getString(key: .access_token)
        let auth = "Bearer \(access_token)"
        
        var params: [String: Any] = [:]
        params["user_id"] = user_id
        params["timeline_id"] = timeline_id
        
        HTTPRequest.shared.headers[.xplatform] = "IOS"
        HTTPRequest.shared.headers[.authorization] = auth
        HTTPRequest.shared.connect(url: url_request, params: params, model: MainResponse<String>.self) { (result) in
            completion(result)
        }
    }
    
    func deleteTimeline(timeline_id: Int, completion: @escaping (Result<MainResponse<String>, Error>) -> Void) {
        let base_url = URLConst.server + URLConst.path_v1
        let url_request = "\(base_url)/timeline/delete/\(timeline_id)"
        let access_token = UDHelpers.shared.getString(key: .access_token)
        let auth = "Bearer \(access_token)"
        
        HTTPRequest.shared.method = .DELETE
        HTTPRequest.shared.headers[.authorization] = auth
        HTTPRequest.shared.connect(url: url_request, params: nil, model: MainResponse<String>.self) { (result) in
            completion(result)
        }
    }
}
