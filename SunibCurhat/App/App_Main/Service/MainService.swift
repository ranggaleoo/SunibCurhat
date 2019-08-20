//
//  MainService.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 17/08/19.
//  Copyright © 2019 Rangga Leo. All rights reserved.
//

import Foundation
import UIKit

class MainService {
    
    static let shared: MainService = MainService()
    
    func getToken(completion: @escaping (Result<MainResponse<[String:String]>, Error>) -> Void) {
        let url = URLConst.api_url + "/getToken"
        HTTPRequest.shared.connect(url: url, params: nil, model: [String:String].self) { (result) in
            completion(result)
        }
    }
}
