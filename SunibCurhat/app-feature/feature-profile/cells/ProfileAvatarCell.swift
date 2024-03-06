//
//  ProfileAvatarCell.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 05/03/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import UIKit
import Kingfisher

class ProfileAvatarCell: UITableViewCell {
    
    @IBOutlet private weak var image_profile: UIImageView!
    @IBOutlet private weak var lbl_username: UINCLabelTitle!
    
    struct source {
        static var nib: UINib = UINib(nibName: String(describing: ProfileAvatarCell.self), bundle: Bundle(for: ProfileAvatarCell.self))
        static var identifier: String = String(describing: ProfileAvatarCell.self)
    }
    
    private let user: User? = UDHelpers.shared.getObject(type: User.self, forKey: .user)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    private func setupViews() {
        selectionStyle = .none
        backgroundColor = UINCColor.bg_primary
        
        lbl_username.changeFontSize(size: 14)
        lbl_username.textColor = UIColor.label
        lbl_username.textAlignment = .center
        
        if let username = user?.name {
            lbl_username.text = username
            image_profile.setImageForName(string: username, circular: true)
        }
        
        if let url_avatar = URL(string: user?.avatar ?? "") {
            image_profile.circleCorner = true
            image_profile.kf.setImage(with: url_avatar)
            image_profile.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
    }
}
