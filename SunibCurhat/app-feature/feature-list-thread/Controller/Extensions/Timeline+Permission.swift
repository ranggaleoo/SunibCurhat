//
//  Timeline+Permission.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 02/05/20.
//  Copyright © 2020 Rangga Leo. All rights reserved.
//

import Foundation
import SPPermissions

extension ListCurhatViewController: SPPermissionDialogDelegate {}

extension ListCurhatViewController: SPPermissionDialogDataSource {
    func description(for permission: SPPermissionType) -> String? {
        switch permission {
        case .camera            : return UIApplication.shared.infoPlist(key: .NSCameraUsageDescription)
        case .photoLibrary      : return UIApplication.shared.infoPlist(key: .NSPhotoLibraryUsageDescription)
        case .contacts          : return UIApplication.shared.infoPlist(key: .NSContactsUsageDescription)
        default: return "Need Allow for use this Application"
        }
    }
}
