//
//  FeedDefaultCell.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 27/11/20.
//  Copyright © 2020 Rangga Leo. All rights reserved.
//

import UIKit

protocol FeedDefaultCellDelegate: class {
    func didTapLike(cell: FeedDefaultCell)
    func didTapComment(cell: FeedDefaultCell)
    func didTapShare(cell: FeedDefaultCell)
    func didTapMore(cell: FeedDefaultCell)
}

class FeedDefaultCell: UITableViewCell {
    
    @IBOutlet weak var container_round: UIView!
    @IBOutlet weak var image_profile: UIImageView!
    @IBOutlet weak var lbl_username: UINCLabelTitle!
    @IBOutlet weak var lbl_time: UINCLabelNote!
    @IBOutlet weak var lbl_textcontent: UINCLabelBody!
    @IBOutlet weak var lbl_like_counter: UINCLabelNote!
    @IBOutlet weak var lbl_comment_counter: UINCLabelNote!
    @IBOutlet weak var btn_share: UIButton!
    @IBOutlet weak var btn_like: UIButton!
    @IBOutlet weak var btn_comment: UIButton!
    @IBOutlet weak var btn_more: UIButton!
    
    struct source {
        static var nib: UINib = UINib(nibName: String(describing: FeedDefaultCell.self), bundle: Bundle(for: FeedDefaultCell.self))
        static var identifier: String = String(describing: FeedDefaultCell.self)
    }
    
    var timeline: TimelineItems? {
        didSet {
            self.updateUI()
        }
    }
    
    var isLiked: Bool = false {
        didSet {
            if isLiked {
                var image: UIImage?
                if #available(iOS 13.0, *) {
                    image = UIImage(symbol: .heart_fill, configuration: nil)?.withTintColor(UIColor.custom.red_absolute, renderingMode: .alwaysOriginal)
                } else {
                    image = UIImage(named: "btn_like_active")
                }
                btn_like.setImage(image, for: .normal)
            
            } else {
                var image: UIImage?
                if #available(iOS 13.0, *) {
                    image = UIImage(symbol: .heart, configuration: nil)?.withTintColor(UIColor.custom.black_absolute, renderingMode: .alwaysOriginal)
                } else {
                    image = UIImage(named: "btn_like")
                }
                btn_like.setImage(image, for: .normal)
            }
        }
    }
    
    weak var delegate: FeedDefaultCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    private func setupViews() {
        selectionStyle = .none
        btn_share.addTarget(self, action: #selector(actionShare(_:)), for: .touchUpInside)
        btn_like.addTarget(self, action: #selector(actionLike(_:)), for: .touchUpInside)
        btn_comment.addTarget(self, action: #selector(actionComment(_:)), for: .touchUpInside)
        btn_more.addTarget(self, action: #selector(actionMore(_:)), for: .touchUpInside)
    }
    
    private func updateUI() {
        container_round.layer.cornerRadius     = 15
        container_round.layer.shadowColor      = UIColor.black.withAlphaComponent(0.25).cgColor
        container_round.layer.shadowOffset     = CGSize(width: 0, height: 0)
        container_round.layer.shadowRadius     = 10.0
        container_round.layer.shadowOpacity    = 30.0
        container_round.layer.masksToBounds    = false
        
        lbl_username.text               = timeline?.name
        lbl_textcontent.text            = timeline?.text_content
        lbl_textcontent.numberOfLines   = 0
        lbl_textcontent.textAlignment   = .natural
        lbl_time.text                   = timeline?.timed.toDate(format: "yyyy-MM-dd HH:mm:ss")?.timeAgo(numericDates: true)
        isLiked                         = timeline?.is_liked ?? false
        
        lbl_username.changeFontSize(size: 14)
        lbl_time.changeFontSize(size: 12)
        lbl_textcontent.changeFontSize(size: 14)
        lbl_like_counter.changeFontSize(size: 12)
        lbl_comment_counter.changeFontSize(size: 12)
        lbl_textcontent.changeParagraphLineSpacing(size: 5)
        
        if let likes = timeline?.total_likes, likes > 0 {
            lbl_like_counter.text = "\(likes)"
        } else {
            lbl_like_counter.text = ""
        }
        
        if let comments = timeline?.total_comments, comments > 0 {
            lbl_comment_counter.text = "\(comments)"
        } else {
            lbl_comment_counter.text = ""
        }
        
        if let username = timeline?.name {
            image_profile.setImageForName(string: username, circular: true)
        }
        
        var image_comment: UIImage?
        var image_share: UIImage?
        if #available(iOS 13.0, *) {
            image_comment = UIImage(symbol: .bubble_right, configuration: nil)?.withTintColor(UIColor.custom.black_absolute, renderingMode: .alwaysOriginal)
            image_share = UIImage(symbol: .share, configuration: nil)?.withTintColor(UIColor.custom.black_absolute, renderingMode: .alwaysOriginal)
        } else {
            image_comment   = UIImage(named: "btn_comment")
            image_share     = UIImage(named: "btn_share")
        }
        
        btn_comment.setImage(image_comment, for: .normal)
        btn_share.setImage(image_share, for: .normal)
    }
    
    @objc func actionShare(_ sender: UIButton) {
        delegate?.didTapShare(cell: self)
    }
    
    @objc func actionLike(_ sender: UIButton) {
        delegate?.didTapLike(cell: self)
    }
    
    @objc func actionComment(_ sender: UIButton) {
        delegate?.didTapComment(cell: self)
    }
    
    @objc func actionMore(_ sender: UIButton) {
        delegate?.didTapMore(cell: self)
    }
}
