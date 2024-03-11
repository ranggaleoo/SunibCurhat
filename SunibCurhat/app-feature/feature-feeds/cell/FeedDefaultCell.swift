//
//  FeedDefaultCell.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 27/11/20.
//  Copyright © 2020 Rangga Leo. All rights reserved.
//

import UIKit
import Kingfisher

protocol FeedDefaultCellDelegate: AnyObject {
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
                let image: UIImage? = UIImage(symbol: .HeartFill)?
                    .withTintColor(UIColor.custom.red_absolute, renderingMode: .alwaysOriginal)
                btn_like.setImage(image, for: .normal)
            
            } else {
                let image: UIImage? = UIImage(symbol: .Heart)?
                    .withTintColor(UIColor.label, renderingMode: .alwaysOriginal)
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
        backgroundColor = UINCColor.bg_primary
        
        container_round.layer.cornerRadius     = 15
        container_round.layer.shadowColor      = UIColor.black.withAlphaComponent(0.25).cgColor
        container_round.layer.shadowOffset     = CGSize(width: 0, height: 0)
        container_round.layer.shadowRadius     = 10.0
        container_round.layer.shadowOpacity    = 30.0
        container_round.layer.borderColor      = UINCColor.bg_tertiary.cgColor
        container_round.layer.borderWidth      = 1
        container_round.layer.masksToBounds    = false
        
        lbl_textcontent.numberOfLines   = 0
        lbl_textcontent.textAlignment   = .justified
        
        lbl_username.changeFontSize(size: 14)
        lbl_time.changeFontSize(size: 12)
        lbl_textcontent.changeFontSize(size: 14)
        lbl_like_counter.changeFontSize(size: 12)
        lbl_comment_counter.changeFontSize(size: 12)
        lbl_textcontent.changeParagraphLineSpacing(size: 5)
        
        lbl_username.textColor = UIColor.label
        lbl_textcontent.textColor = UIColor.label
        lbl_time.textColor = UIColor.secondaryLabel
        lbl_like_counter.textColor = UIColor.secondaryLabel
        lbl_comment_counter.textColor = UIColor.secondaryLabel
        
        let image_comment: UIImage? = UIImage(symbol: .BubbleRight)?
            .withTintColor(UIColor.label, renderingMode: .alwaysOriginal)
        let image_share: UIImage? = UIImage(symbol: .SquareAndArrowUp)?
            .withTintColor(UIColor.label, renderingMode: .alwaysOriginal)
        let image_more: UIImage? = UIImage(symbol: .Ellipsis)?
            .withTintColor(UIColor.label, renderingMode: .alwaysOriginal)
        btn_comment.setImage(image_comment, for: .normal)
        btn_share.setImage(image_share, for: .normal)
        btn_more.setImage(image_more, for: .normal)
        
        btn_share.addTarget(self, action: #selector(actionShare(_:)), for: .touchUpInside)
        btn_like.addTarget(self, action: #selector(actionLike(_:)), for: .touchUpInside)
        btn_comment.addTarget(self, action: #selector(actionComment(_:)), for: .touchUpInside)
        btn_more.addTarget(self, action: #selector(actionMore(_:)), for: .touchUpInside)
    }
    
    private func updateUI() {
        lbl_username.text               = timeline?.user?.name
        lbl_textcontent.text            = timeline?.text_content
        lbl_time.text                   = timeline?.created_at.toDate(format: "yyyy-MM-dd HH:mm:ss")?.timeAgo(numericDates: true)
        isLiked                         = timeline?.is_liked ?? false
        
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
        
        if let username = timeline?.user?.name {
            image_profile.setImageForName(string: username, circular: true)
        }
        
        if let avatar = timeline?.user?.avatar,
           let url_avatar = URL(string: avatar)
        {
            image_profile.circleCorner = true
            image_profile.kf.setImage(with: url_avatar)
        }
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
