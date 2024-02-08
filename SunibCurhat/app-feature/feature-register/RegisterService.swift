//
//  RegisterService.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 09/02/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import Foundation

class RegisterService {
    static let shared: RegisterService = RegisterService()
    
    func register(device_id: String, email: String, password: String, completion: @escaping (Result<MainResponse<String>, Error>) -> Void) {
        let base_url = URLConst.server + URLConst.path_v1
        var params: [String: Any] = [:]
        params["device_id"] = device_id
        params["email"] = email
        params["password"] = password
        HTTPRequest.shared.headers[.xplatform] = "IOS"
        HTTPRequest.shared.connect(url: base_url + "/register/user/", params: params, model: MainResponse<String>.self) { (result) in
            completion(result)
        }
    }
}
