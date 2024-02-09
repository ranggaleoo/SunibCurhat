//
//  Identifier.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 01/05/20.
//  Copyright © 2020 Rangga Leo. All rights reserved.
//

import Foundation

public enum Identifier {
    
    public enum infoPlist: String {
        case NSCameraUsageDescription
        case NSContactsUsageDescription
        case NSPhotoLibraryUsageDescription
        case NSLocationWhenInUseUsageDescription
    }
    
    public enum imageName: String {
        // MARK: - ICON APP
        case AppIcon
        
        // MARK: - IMAGE ASSETS
        case image_super_thankyou
        case image_logo
        
        // MARK: - BUTTON
        case btn_camera
    }
    
    @available(*, deprecated, renamed: "SFSymbols", message: "use enum SFSymbols generated instead")
    public enum imageSymbolName: String {
        // MARK: - INFO
        case info               = "info"
        case info_circle        = "info.circle"
        case info_circle_fill   = "info.circle.fill"
        
        // MARK: - HEART
        case heart              = "heart"
        case heart_fill         = "heart.fill"
        case heart_circle       = "heart.circle"
        case heart_circle_fill  = "heart.circle.fill"
        
        // MARK: - BUBBLE
        case bubble_right       = "bubble.right"
        case bubble_right_fill  = "bubble.right.fill"
        case bubble_left        = "bubble.left"
        case bubble_left_fill   = "bubble.left.fill"
        
        // MARK: - TEXT BUBBLE
        case text_bubble        = "text.bubble"
        case text_bubble_fill   = "text.bubble.fill"
        
        // MARK: - PLUS BUBBLE
        case plus_bubble        = "plus.bubble"
        case plus_bubble_fill   = "plus.bubble.fill"
        
        // MARK: - DOUBLE BUBBLE
        case double_bubble      = "bubble.left.and.bubble.right"
        case double_bubble_fill = "bubble.left.and.bubble.right.fill"
        
        // MARK: - SHARE
        case share              = "square.and.arrow.up"
        case share_fill         = "square.and.arrow.up.fill"
        
        // MARK: - BANDAGE
        case bandage            = "bandage"
        case bandage_fill       = "bandage.fill"
        
        // MARK: - SHIELD
        case shield_checkmark       = "checkmark.shield"
        case shield_checkmark_fill  = "checkmark.shield.fill"
    }
}
