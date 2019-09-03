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
    
    func getAdBannerUnitID(completion: @escaping (Result<MainResponse<String>, Error>) -> Void) {
        let url = URLConst.api_url + "/getAdBannerUnitID"
        HTTPRequest.shared.connect(url: url, params: nil, model: String.self) { (result) in
            completion(result)
        }
    }
    
    func sendNotif(title: String, text: String, fcmToken: String, completion: @escaping (Result<MainResponse<String>, Error>) -> Void) {
        let url                     = URLConst.fcm_url
        var param: [String: Any]    = [:]
        param["to"]                 = fcmToken
        param["content_available"]  = true
        param["priority"]           = "high"
        param["notification"]       = [
            "notification-type" : "chat",
            "target"            : "Current User",
            "title"             : title,
            "text"              : text,
            "badge"             : 5  //Badge you want to show on app icon
        ]
        
        HTTPRequest.shared.headers[.authorization]  = "key=" + ConstGlobal.SERVER_KEY_FCM
        HTTPRequest.shared.headers[.contentType]    = "application/json"
        
        HTTPRequest.shared.connect(url: url, params: param, model: String.self) { (result) in
            completion(result)
        }
    }
    
    func downloadMedia(url: String, completion: @escaping (Result<String, Error>, Data?) -> Void) {
        HTTPRequest.shared._connect(url: url, params: nil, model: String.self) { (result, data) in
            completion(result, data)
        }
    }
}
