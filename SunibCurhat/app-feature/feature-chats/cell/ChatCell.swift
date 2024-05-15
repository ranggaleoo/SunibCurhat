//
//  ChatCell.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 24/02/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class ChatCell: UITableViewCell {
    
    @IBOutlet private weak var image_avatar: UIImageView!
    @IBOutlet private weak var lbl_name: UINCLabelTitle!
    @IBOutlet private weak var lbl_last_chat: UINCLabelBody!
    @IBOutlet private weak var lbl_time: UINCLabelNote!
    @IBOutlet private weak var status_view: UIView!
    
    struct source {
        static var nib: UINib = UINib(nibName: String(describing: ChatCell.self), bundle: Bundle(for: ChatCell.self))
        static var identifier: String = String(describing: ChatCell.self)
    }
    
    private var conversation: Conversation? {
        didSet {
            updateUI()
        }
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
        
        image_avatar.circleCorner = true
        status_view.circleCorner = true
        status_view.backgroundColor = .clear
    }
    
    func set(conversation: Conversation?) {
        self.conversation = conversation
    }
    
    private func updateUI() {
        let user = conversation?.them().first
        
        if let username = user?.name {
            lbl_name.text = username
            image_avatar.setImage(string: username, circular: true)
        }
        
        if let urlAvatar = URL(string: user?.avatar ?? "") {
            image_avatar.circleCorner = true
            image_avatar.kf.setImage(with: urlAvatar)
        }
        
        status_view.backgroundColor = (conversation?.them().first?.is_online ?? false) ? UINCColor.success : .clear
        
        lbl_last_chat.text = conversation?.last_chat ?? "Chat aku dong!"
        lbl_time.text = conversation?
            .last_chat_timestamp?
            .unixTimestampMillisecondsToDate()
            .timeAgo(numericDates: true)
        
        if conversation?.isBlocked ?? false {
            if conversation?.isBlockedByMe ?? false {
                lbl_last_chat.text = "You have blocked this account."
            } else {
                lbl_last_chat.text = "You have been blocked by \(user?.name ?? "")"
            }
        }
    }
}
