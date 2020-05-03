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
    
    func report(reportByDevice: String, device_id: String, reason: String, proof_id: String?, proof: String?, completion: @escaping (Result<MainResponse<String>, Error>) -> Void) {
        let url = URLConst.api_url + "/report"
        var param: [String: Any]    = [:]
        param["report_by"]          = reportByDevice
        param["device_id"]          = device_id
        param["reason"]             = reason
        param["proof_id"]           = proof_id
        param["proof"]              = proof
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
