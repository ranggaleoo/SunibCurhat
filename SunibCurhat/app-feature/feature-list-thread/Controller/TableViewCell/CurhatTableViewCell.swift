//
//  CurhatTableViewCell.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 04/08/19.
//  Copyright © 2019 Rangga Leo. All rights reserved.
//

import Foundation
import UIKit

class CurhatTableViewCell: UITableViewCell {
    @IBOutlet weak var container_view: UIView!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_curhat: UILabel!
    @IBOutlet weak var lbl_count_likes: UILabel!
    @IBOutlet weak var lbl_count_comments: UILabel!
    @IBOutlet weak var lbl_count_shares: UILabel!
    @IBOutlet weak var lbl_time: UILabel!
    @IBOutlet weak var btn_likes: UIButton!
    @IBOutlet weak var btn_comment: UIButton!
    @IBOutlet weak var btn_share: UIButton!
    
    var btn_likes_clicked: ((UIButton) -> Void)?
    var btn_comments_clicked: ((UIButton) -> Void)?
    var btn_shares_clicked: ((UIButton) -> Void)?
    var btn_more_clicked: ((UIButton) -> Void)?
    
    var timeline: TimelineItems? {
        didSet {
            self.updateUI()
        }
    }
    
    var isLiked: Bool = false {
        didSet {
            if isLiked {
                DispatchQueue.main.async {
                    var image: UIImage?
                    if #available(iOS 13.0, *) {
                        image = UIImage(symbol: .HeartFill, configuration: nil)?.withTintColor(UIColor.custom.red_absolute, renderingMode: .alwaysOriginal)
                    } else {
                        image = UIImage(named: "btn_like_active")
                    }
                    self.btn_likes.setImage(image, for: .normal)
                }
            
            } else {
                DispatchQueue.main.async {
                    var image: UIImage?
                    if #available(iOS 13.0, *) {
                        image = UIImage(symbol: .Heart, configuration: nil)?.withTintColor(UIColor.custom.black_absolute, renderingMode: .alwaysOriginal)
                    } else {
                        image = UIImage(named: "btn_like")
                    }
                    self.btn_likes.setImage(image, for: .normal)
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    private func updateUI() {
        self.container_view.layer.cornerRadius     = 5
        self.container_view.layer.shadowColor      = UIColor.black.withAlphaComponent(0.25).cgColor
        self.container_view.layer.shadowOffset     = CGSize(width: 0, height: 0)
        self.container_view.layer.shadowRadius     = 10.0
        self.container_view.layer.shadowOpacity    = 30.0
        self.container_view.layer.masksToBounds    = false
        
        self.lbl_name.text          = self.timeline?.name
        self.lbl_curhat.text        = self.timeline?.text_content
        self.lbl_time.text          = self.timeline?.timed.toDate(format: "yyyy-MM-dd HH:mm:ss")?.timeAgo(numericDates: true)
        self.isLiked                = self.timeline?.is_liked ?? false
        
        let likes = self.timeline?.total_likes > 0 ? "\(self.timeline?.total_likes ?? 0)" : ""
        self.lbl_count_likes.text       = likes + " likes"
        
        let comments = self.timeline?.total_comments > 0 ? "\(self.timeline?.total_comments ?? 0)" : ""
        self.lbl_count_comments.text    = comments + " comments"
        
        let shares = self.timeline?.total_shares > 0 ? "\(self.timeline?.total_shares ?? 0)" : ""
        self.lbl_count_shares.text      = shares + " shares"
        
        var image_comment: UIImage?
        var image_share: UIImage?
        if #available(iOS 13.0, *) {
            image_comment = UIImage(symbol: .BubbleRight, configuration: nil)?.withTintColor(UIColor.custom.black_absolute, renderingMode: .alwaysOriginal)
            image_share = UIImage(symbol: .SquareAndArrowUp, configuration: nil)?.withTintColor(UIColor.custom.black_absolute, renderingMode: .alwaysOriginal)
        } else {
            image_comment   = UIImage(named: "btn_comment")
            image_share     = UIImage(named: "btn_share")
        }
        
        self.btn_comment.setImage(image_comment, for: .normal)
        self.btn_share.setImage(image_share, for: .normal)
    }
    
    @IBAction private func actionLike(_ sender: UIButton) {
        btn_likes_clicked?(sender)
    }
    
    @IBAction private func actionComment(_ sender: UIButton) {
        btn_comments_clicked?(sender)
    }
    
    @IBAction private func actionShare(_ sender: UIButton) {
        btn_shares_clicked?(sender)
    }
    
    @IBAction private func actionMore(_ sender: UIButton) {
        btn_more_clicked?(sender)
    }
    
}
