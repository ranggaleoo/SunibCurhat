//
//  URLConst.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 17/08/19.
//  Copyright © 2019 Rangga Leo. All rights reserved.
//

import Foundation

struct URLConst {
    
    // MARK: - DEVELOPMENT
//    static let server_core          = "https://ranggaleo.com"
//    static let server               = "https://2395900f.ngrok.io"
//    static let api_path             = "/web_semua_bisa/id/apisunibcurhat"
    static let server_sb            = "https://eb3eb79a.ngrok.io"
    static let api_path_sb          = "/web_semua_bisa/id/apisemuabisa"
    static let api_corona           = "https://api.kawalcorona.com"
    
    // MARK: - PRODUCTION
    static let server_core          = "https://ranggaleo.com"
    static var server               = ""
    static let api_path             = "/id/apisunibcurhat"
    
    static let path_v1              = "/api/v1"
    
    // API_URL
    static let base_api_url         = server + path_v1
    static let api_url              = server + api_path
    static let api_url_sb           = server_sb + api_path_sb
    static let fcm_url              = "https://fcm.googleapis.com/fcm/send"
}
