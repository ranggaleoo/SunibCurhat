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
//    static let server               = "https://3ae8012f.ngrok.io"
//    static let api_path             = "/web_semua_bisa/id/apisunibcurhat"
    
    // MARK: - PRODUCTION
    static let server               = "https://semuabisa.ga"
    static let api_path             = "/id/apisunibcurhat"
    
    // API_URL
    static let api_url              = server + api_path
    static let fcm_url              = "https://fcm.googleapis.com/fcm/send"
}
