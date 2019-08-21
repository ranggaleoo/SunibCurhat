//
//  CommentService.swift
//  SunibCurhat
//
//  Created by Koinworks on 8/21/19.
//  Copyright © 2019 Rangga Leo. All rights reserved.
//

import Foundation

class CommentService {
    static let shared: CommentService = CommentService()
    
    func getComments(timeline_id: Int, completion: @escaping (Result<MainResponse<[TimelineResponse]>, Error>) -> Void) {
        var param: [String: Any] = [:]
        param["timeline_id"] = timeline_id
        
        if let token = RepoMemory.token {
            param["X_SIGNATURE_API"] = token
        }
        
        let url = URLConst.api_url + "/getComments"
        HTTPRequest.shared.headers[.contentType] = "application/json; charset=utf-8"
        HTTPRequest.shared.headers[.referer] = URLConst.server
        HTTPRequest.shared.connect(url: url, params: param, model: [TimelineResponse].self) { (result) in
            completion(result)
        }
    }
}
