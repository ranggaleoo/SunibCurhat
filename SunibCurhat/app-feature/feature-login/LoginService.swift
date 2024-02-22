//
//  LoginService.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 08/02/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import Foundation

class LoginService {
    static let shared: LoginService = LoginService()
    
    func login(device_id: String, email: String, password: String, completion: @escaping (Result<MainResponse<BaseLoginData>, Error>) -> Void) {
        let base_url = URLConst.server + URLConst.path_v1
        var params: [String: Any] = [:]
        params["device_id"] = device_id
        params["email"] = email
        params["password"] = password
        HTTPRequest.shared.headers[.xplatform] = "IOS"
        HTTPRequest.shared.connect(url: base_url + "/login/user/", params: params, model: MainResponse<BaseLoginData>.self) { (result) in
            completion(result)
        }
    }
    
    func loginAsAnonymous(device_id: String, completion: @escaping (Result<MainResponse<BaseLoginData>, Error>) -> Void) {
        let base_url = URLConst.server + URLConst.path_v1
        var params: [String: Any] = [:]
        params["device_id"] = device_id
        HTTPRequest.shared.headers[.xplatform] = "IOS"
        HTTPRequest.shared.connect(url: base_url + "/login/anon/", params: params, model: MainResponse<BaseLoginData>.self) { (result) in
            completion(result)
        }
    }
}
