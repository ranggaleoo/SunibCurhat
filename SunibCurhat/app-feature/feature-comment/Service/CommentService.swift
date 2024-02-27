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
    
    @available(*, deprecated, renamed: "addNewComment", message: "use addNewComment instead")
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
    
    func addNewComment(timeline_id: Int, user_id: String, name: String, text_content: String, completion: @escaping (Result<MainResponse<String>, Error>) -> Void) {
        let base_url = URLConst.server + URLConst.path_v1
        let url_request = "\(base_url)/comment/new/"
        let access_token = UDHelpers.shared.getString(key: .access_token) ?? ""
        let auth = "Bearer \(access_token)"
        
        var params: [String: Any] = [:]
        params["timeline_id"]   = timeline_id
        params["user_id"]       = user_id
        params["name"]          = name
        params["text_content"]  = text_content
        
        HTTPRequest.shared.headers[.xplatform] = "IOS"
        HTTPRequest.shared.headers[.authorization] = auth
        HTTPRequest.shared.connect(url: url_request, params: params, model: MainResponse<String>.self) { (result) in
            completion(result)
        }
    }
    
    func getCommentsByTimelineId(timeline_id: Int, page: Int, itemPerPage: Int, completion: @escaping (Result<MainResponse<CommentResponse>, Error>) -> Void) {
        let base_url = URLConst.server + URLConst.path_v1
        let url_request = "\(base_url)/comment/\(timeline_id)/\(page)/\(itemPerPage)"
        let access_token = UDHelpers.shared.getString(key: .access_token) ?? ""
        let auth = "Bearer \(access_token)"
        
        HTTPRequest.shared.headers[.xplatform] = "IOS"
        HTTPRequest.shared.headers[.authorization] = auth
        HTTPRequest.shared.connect(url: url_request, params: nil, model: MainResponse<CommentResponse>.self) { (result) in
            completion(result)
        }
    }
    
    @available(*, deprecated, renamed: "getCommentsByTimelineId", message: "use getCommentsByTimelineId instead")
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
    
    func deleteComment(comment_id: String, completion: @escaping (Result<MainResponse<String>, Error>) -> Void) {
        let url = URLConst.api_url + "/deleteComment"
        var param: [String: Any] = [:]
        param["comment_id"] = comment_id
        
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
