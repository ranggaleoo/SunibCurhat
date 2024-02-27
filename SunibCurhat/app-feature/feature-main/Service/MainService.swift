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
    
    func getUser(completion: @escaping (Result<MainResponse<User>, Error>) -> Void) {
        let base_url = URLConst.server + URLConst.path_v1
        let access_token = UDHelpers.shared.getString(key: .access_token) ?? ""
        let auth = "Bearer \(access_token)"
        HTTPRequest.shared.headers[.authorization] = auth
        HTTPRequest.shared.connect(url: base_url + "/user/me/", params: nil, model: MainResponse<User>.self) { (result) in
            completion(result)
        }
    }
    
    func getPreferences(completion: @escaping (Result<MainResponse<Preferences>, Error>) -> Void) {
        let base_url = URLConst.server + URLConst.path_v1
        HTTPRequest.shared.connect(url: base_url + "/preferences/", params: nil, model: MainResponse<Preferences>.self) { (result) in
            completion(result)
        }
    }
    
    func refreshToken(completion: @escaping (Result<MainResponse<RefreshTokenData>, Error>) -> Void) {
        let base_url = URLConst.server + URLConst.path_v1
        HTTPRequest.shared.headers[.authorization] = UDHelpers.shared.getString(key: .refresh_token)
        HTTPRequest.shared.connect(url: base_url + "/auth/refresh/", params: nil, model: MainResponse<RefreshTokenData>.self) { (result) in
            completion(result)
        }
    }
    
    func logout(completion: @escaping (Result<MainResponse<String>, Error>) -> Void) {
        let base_url = URLConst.server + URLConst.path_v1
        let access_token = UDHelpers.shared.getString(key: .access_token) ?? ""
        let auth = "Bearer \(access_token)"
        HTTPRequest.shared.headers[.authorization] = auth
        HTTPRequest.shared.connect(url: base_url + "/logout", params: nil, model: MainResponse<String>.self) { (result) in
            completion(result)
        }
    }
    
    func getEndpoint(completion: @escaping (Result<MainResponse<EndpointResponse>, Error>) -> Void) {
        let url = URLConst.server_core + "/project/router/"
        var params: [String: Any] = [:]
        params["service"] = "ENDPOINT_NETIJEN_CURHAT"
        
        HTTPRequest.shared.connect(url: url, params: params, model: MainResponse<EndpointResponse>.self) { (result) in
            completion(result)
        }
    }
    
    @available(*, deprecated, renamed: "refreshToken", message: "use refreshToken instead")
    func getToken(completion: @escaping (Result<MainResponse<[String:String]>, Error>) -> Void) {
        let url = URLConst.api_url + "/getToken"
        HTTPRequest.shared.connect(url: url, params: nil, model: MainResponse<[String:String]>.self) { (result) in
            completion(result)
        }
    }
    
    func getAdBannerUnitID(completion: @escaping (Result<MainResponse<String>, Error>) -> Void) {
        let url = URLConst.api_url + "/getAdBannerUnitID"
        HTTPRequest.shared.connect(url: url, params: nil, model: MainResponse<String>.self) { (result) in
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
        
        HTTPRequest.shared.connect(url: url, params: param, model: MainResponse<String>.self) { (result) in
            completion(result)
        }
    }
    
    func adsClicked(ad_unit_id: Int, completion: @escaping (Result<MainResponse<String>, Error>) -> Void) {
        let url = URLConst.api_url + "/adsClicked"
        var param: [String: Any]    = [:]
        param["ad_unit_id"] = ad_unit_id
        if let token = RepoMemory.token {
            param["X_SIGNATURE_API"] = token
        }
        HTTPRequest.shared.connect(url: url, params: param, model: MainResponse<String>.self) { (result) in
            completion(result)
        }
    }
}
