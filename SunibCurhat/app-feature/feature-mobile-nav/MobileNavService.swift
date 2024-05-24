//
//  MobileNavService.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 05/03/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import Foundation


class MobileNavService {
    static let shared = MobileNavService()
    
    func getMobileNavigation(completion: @escaping (Result<MainResponse<[MobileNavigationPage]>, Error>) -> Void) {
        let base_url = URLConst.server + URLConst.path_v1
        let url_request = base_url + "/mobile-navigations/"
        let access_token = UDHelpers.shared.getString(key: .access_token) ?? ""
        let auth = "Bearer \(access_token)"
        HTTPRequest.shared.headers[.authorization] = auth
        HTTPRequest.shared.connect(url: url_request, params: nil, model: MainResponse<[MobileNavigationPage]>.self) { (result) in
            completion(result)
        }
        
    }
    
    func hitAPI(path: String, completion: @escaping(Result<MainResponse<String>, Error>) -> Void) {
        let base_url = URLConst.server + URLConst.path_v1
        let url_request = base_url + path
        let access_token = UDHelpers.shared.getString(key: .access_token) ?? ""
        let auth = "Bearer \(access_token)"
        HTTPRequest.shared.headers[.authorization] = auth
        HTTPRequest.shared.connect(url: url_request, params: nil, model: MainResponse<String>.self) { (result) in
            completion(result)
        }
    }
}
