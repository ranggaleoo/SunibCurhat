//
//  NewPostService.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 10/02/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import Foundation

class NewPostService {
    static let shared: NewPostService = NewPostService()
    
    func newPost(user_id: String, name: String, text_content: String, completion: @escaping (Result<MainResponse<String>, Error>) -> Void) {
        let base_url = URLConst.server + URLConst.path_v1
        let url_request = "\(base_url)/timeline/new/"
        let access_token = UDHelpers.shared.getString(key: .access_token) ?? ""
        let auth = "Bearer \(access_token)"
        
        var params: [String: Any] = [:]
        params["user_id"] = user_id
        params["name"] = name
        params["text_content"] = text_content
        
        HTTPRequest.shared.headers[.xplatform] = "IOS"
        HTTPRequest.shared.headers[.authorization] = auth
        HTTPRequest.shared.connect(url: url_request, params: params, model: MainResponse<String>.self) { (result) in
            completion(result)
        }
    }
}
