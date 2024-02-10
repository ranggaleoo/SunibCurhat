//
//  CommentCell.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 10/02/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import Foundation
import UIKit

class CommentCell: UITableViewCell {
    @IBOutlet private weak var image_profile: UIImageView!
    @IBOutlet private weak var lbl_username: UINCLabelTitle!
    @IBOutlet private weak var lbl_time: UINCLabelNote!
    @IBOutlet private weak var lbl_textcontent: UINCLabelBody!
    @IBOutlet private weak var btn_more: UIButton!
    
    struct source {
        static var nib: UINib = UINib(nibName: String(describing: CommentCell.self), bundle: Bundle(for: CommentCell.self))
        static var identifier: String = String(describing: CommentCell.self)
    }
    
    var comment: CommentItems? {
        didSet {
            self.updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    private func setupViews() {
        selectionStyle = .none
        
        lbl_textcontent.numberOfLines = 0
        lbl_textcontent.textAlignment = .natural
        
        lbl_username.textColor = UIColor.label
        lbl_textcontent.textColor = UIColor.label
        lbl_time.textColor = UIColor.secondaryLabel
        
        lbl_username.changeFontSize(size: 12)
        lbl_textcontent.changeFontSize(size: 12)
        lbl_time.changeFontSize(size: 10)
    }
    
    private func updateUI() {
        if let username = comment?.name {
            image_profile.setImageForName(string: username, circular: true)
        }
        
        if let avatar = comment?.avatar,
           let url_avatar = URL(string: avatar)
        {
            image_profile.circleCorner = true
            image_profile.kf.setImage(with: url_avatar)
        }
        
        lbl_username.text = comment?.name
        lbl_time.text = comment?.created_at.toDate(format: "yyyy-MM-dd HH:mm:ss")?.timeAgo(numericDates: true)
        lbl_textcontent.text = comment?.text_content
    }
}
