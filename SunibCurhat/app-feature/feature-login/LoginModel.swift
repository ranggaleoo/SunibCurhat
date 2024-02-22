//
//  LoginModel.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 08/02/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import Foundation

struct BaseLoginData: Codable {
    let refresh_token: String
    let access_token: String
    let user:         User
}
