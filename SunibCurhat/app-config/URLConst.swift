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
    static let server               = "https://2395900f.ngrok.io"
    static let api_path             = "/web_semua_bisa/id/apisunibcurhat"
    static let server_sb            = "https://eb3eb79a.ngrok.io"
    static let api_path_sb          = "/web_semua_bisa/id/apisemuabisa"
    
    // MARK: - PRODUCTION
//    static let server               = "https://semuabisa.ga"
//    static let api_path             = "/id/apisunibcurhat"
    
    // API_URL
    static let api_url              = server + api_path
    static let api_url_sb           = server_sb + api_path_sb
    static let fcm_url              = "https://fcm.googleapis.com/fcm/send"
}
