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
    
    func addComment(timeline_id: Int, text_content: String, completion: @escaping (Result<MainResponse<String>, Error>) -> Void) {
        var param: [String: Any] = [:]
        param["timeline_id"]    = timeline_id
        param["text_content"]   = text_content
        param["device_id"]      = RepoMemory.device_id
        
        if
            let token = RepoMemory.token,
            let name = RepoMemory.user_name
        {
            param["X_SIGNATURE_API"] = token
            param["name"] = name
        }
        
        let url = URLConst.api_url + "/addComment"
        HTTPRequest.shared.headers[.contentType] = "application/json; charset=utf-8"
        HTTPRequest.shared.headers[.referer] = URLConst.server
        HTTPRequest.shared.connect(url: url, params: param, model: MainResponse<String>.self) { (result) in
            completion(result)
        }
    }
    
    func getComments(page: Int, timeline_id: Int, completion: @escaping (Result<MainResponse<CommentResponse>, Error>) -> Void) {
        var param: [String: Any] = [:]
        param["page"]           = page
        param["limit"]          = 10
        param["timeline_id"]    = timeline_id
        
        if let token = RepoMemory.token {
            param["X_SIGNATURE_API"] = token
        }
        
        let url = URLConst.api_url + "/getComments"
        HTTPRequest.shared.headers[.contentType] = "application/json; charset=utf-8"
        HTTPRequest.shared.headers[.referer] = URLConst.server
        HTTPRequest.shared.connect(url: url, params: param, model: MainResponse<CommentResponse>.self) { (result) in
            completion(result)
        }
    }
}
