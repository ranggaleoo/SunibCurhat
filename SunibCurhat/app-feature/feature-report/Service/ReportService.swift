//
//  ReportService.swift
//  SunibCurhat
//
//  Created by Koinworks on 9/11/19.
//  Copyright © 2019 Rangga Leo. All rights reserved.
//

import Foundation

class ReportService {
    static let shared = ReportService()
    
    func report(reportBy: String, user_id: String, reason: String, proof_id: String?, proof: String?, completion: @escaping (Result<MainResponse<String>, Error>) -> Void) {
        let base_url = URLConst.server + URLConst.path_v1
        let url_request = "\(base_url)/timeline/report/"
        let access_token = UDHelpers.shared.getString(key: .access_token) ?? ""
        let auth = "Bearer \(access_token)"
        
        var param: [String: Any]    = [:]
        param["report_by"]          = reportBy
        param["user_id"]          = user_id
        param["reason"]             = reason
        param["proof_id"]           = proof_id
        param["proof"]              = proof

        HTTPRequest.shared.headers[.xplatform] = "IOS"
        HTTPRequest.shared.headers[.authorization] = auth
        HTTPRequest.shared.connect(url: url_request, params: param, model: MainResponse<String>.self) { (result) in
            completion(result)
        }
    }
}
