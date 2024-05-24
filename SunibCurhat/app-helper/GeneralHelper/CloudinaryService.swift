//
//  CloudinaryService.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 26/03/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import Foundation
import Cloudinary

class CloudinaryService {
    public static let shared: CloudinaryService = CloudinaryService()
    private var cloudinary: CLDCloudinary
    private var pref: PreferenceCloudinary?
    
    init() {
        let preferences = UDHelpers.shared.getObject(type: Preferences.self, forKey: .preferences_key)
        let config = CLDConfiguration(
            cloudName: preferences?.cloudinary?.cloud_name ?? "dubmxbbuc",
            apiKey: preferences?.cloudinary?.tkn ?? ""
        )
        self.cloudinary = CLDCloudinary(configuration: config)
        self.pref = preferences?.cloudinary
    }
    
    public func upload(
        data: Data,
        progress: ((Progress) -> Void)?,
        completion: ((CLDUploadResult?, NSError?) -> Void)?
    ) {
        guard let preset = pref?.preset else {
            fatalError("upload preset not defined \(pref?.preset)")
            return
        }
        cloudinary.createUploader().upload(
            data: data,
            uploadPreset: preset,
            progress: progress,
            completionHandler: completion
        )
    }
}
