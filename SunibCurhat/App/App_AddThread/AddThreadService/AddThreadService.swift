//
//  AddThreadService.swift
//  SunibCurhat
//
//  Created by Koinworks on 8/20/19.
//  Copyright © 2019 Rangga Leo. All rights reserved.
//

import Foundation

class AddThreadService {
    static let shared: AddThreadService = AddThreadService()
    
    func addThread(text_content: String, completion: @escaping (Result<MainResponse<String>, Error>) -> Void) {
        var param: [String: Any] = [:]
        param["device_id"] = RepoMemory.device_id
        param["text_content"] = text_content
        
        if
            let token = RepoMemory.token,
            let name = RepoMemory.user_name
        {
            param["name"] = name
            param["X_SIGNATURE_API"] = token
        }
        
        let url = URLConst.api_url + "/addThread"
        HTTPRequest.shared.headers[.contentType] = "application/json; charset=utf-8"
        HTTPRequest.shared.headers[.referer] = URLConst.server
        HTTPRequest.shared.connect(url: url, params: param, model: String.self) { (result) in
            completion(result)
        }
    }
}
