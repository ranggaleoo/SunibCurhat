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
    @available(*, deprecated, renamed: "server", message: "use server instead")
    static let server_sb            = "https://eb3eb79a.ngrok.io"
    @available(*, deprecated, renamed: "path_v1", message: "use path_v1 instead")
    static let api_path_sb          = "/web_semua_bisa/id/apisemuabisa"
    @available(*, deprecated, renamed: "server", message: "unused api")
    static let api_corona           = "https://api.kawalcorona.com"
    
    // MARK: - PRODUCTION
    static let server_core          = "https://ranggaleo.com"
    static var server               = ""
    
    @available(*, deprecated, renamed: "path_v1", message: "use path_v1 instead")
    static let api_path             = "/id/apisunibcurhat"
    
    static let path_v1              = "/api/v1"
    
    // API_URL
    static let base_api_url         = server + path_v1
    
    @available(*, deprecated, renamed: "base_api_url", message: "use base_api_url instead")
    static let api_url              = server + api_path
    @available(*, deprecated, renamed: "base_api_url", message: "use base_api_url instead")
    static let api_url_sb           = server_sb + api_path_sb
    @available(*, deprecated, renamed: "server", message: "unused fcm")
    static let fcm_url              = "https://fcm.googleapis.com/fcm/send"
}
