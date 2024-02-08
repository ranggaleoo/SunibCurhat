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
        
        HTTPRequest.shared.headers[.authorization] = auth
        HTTPRequest.shared.connect(url: url_request, params: nil, model: MainResponse<TimelineResponse>.self) { (result) in
            completion(result)
        }
    }
}
