//
//  ChatCell.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 24/02/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import Foundation
import UIKit

class ChatCell: UITableViewCell {
    
    @IBOutlet private weak var image_avatar: UIImageView!
    @IBOutlet private weak var lbl_name: UINCLabelTitle!
    @IBOutlet private weak var lbl_last_chat: UINCLabelBody!
    @IBOutlet private weak var lbl_time: UINCLabelNote!
    
    struct source {
        static var nib: UINib = UINib(nibName: String(describing: ChatCell.self), bundle: Bundle(for: ChatCell.self))
        static var identifier: String = String(describing: ChatCell.self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    func setupViews() {
        lbl_last_chat.textAlignment = .natural
        
        lbl_name.changeFontSize(size: 14)
        lbl_last_chat.changeFontSize(size: 14)
        lbl_time.changeFontSize(size: 12)
        
        lbl_name.textColor = UIColor.label
        lbl_last_chat.textColor = UIColor.label
        lbl_time.textColor = UIColor.secondaryLabel
    }
}
