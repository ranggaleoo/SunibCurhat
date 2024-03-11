//
//  CommentView.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 10/02/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import UIKit
import Foundation
import Kingfisher
import InputBarAccessoryView

class CommentView: UIViewController, CommentPresenterToView {
    var presenter: CommentViewToPresenter?
    
    @IBOutlet private weak var stack_container: UIStackView!
    @IBOutlet private weak var image_profile: UIImageView!
    @IBOutlet private weak var lbl_username: UINCLabelTitle!
    @IBOutlet private weak var lbl_time: UINCLabelNote!
    @IBOutlet private weak var lbl_textcontent: UINCLabelBody!
    @IBOutlet private weak var lbl_like_counter: UINCLabelNote!
    @IBOutlet private weak var lbl_comment_counter: UINCLabelNote!
    @IBOutlet private weak var btn_more: UIButton!
    
    @IBOutlet private weak var tbl_comment: UITableView!
    
    private lazy var refreshControl: UIRefreshControl = {
        let r = UIRefreshControl()
        r.tintColor = UIColor.secondaryLabel
        r.attributedTitle = NSAttributedString(string: "Fetching comments..", attributes: [NSAttributedString.Key.font: UIFont.custom.regular.size(of: 12)])
        return r
    }()
    
    @IBOutlet private weak var lbl_reply_message: UINCLabelNote!
    private lazy var input_reply = InputBarAccessoryView()
    
    init() {
        super.init(nibName: String(describing: CommentView.self), bundle: Bundle(for: CommentView.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.didLoad()
    }
    
    func setupViews() {
        title = "Comment"
        view.backgroundColor = UINCColor.bg_primary
        
        lbl_textcontent.textAlignment = .justified
        lbl_textcontent.numberOfLines = 0
        
        lbl_reply_message.numberOfLines = 0
        lbl_reply_message.isHidden = true
        
        lbl_username.changeFontSize(size: 14)
        lbl_textcontent.changeFontSize(size: 14)
        lbl_time.changeFontSize(size: 12)
        lbl_like_counter.changeFontSize(size: 12)
        lbl_comment_counter.changeFontSize(size: 12)
        lbl_reply_message.changeFontSize(size: 12)
        
        lbl_username.textColor = UIColor.label
        lbl_textcontent.textColor = UIColor.label
        lbl_time.textColor = UIColor.secondaryLabel
        lbl_like_counter.textColor = UIColor.secondaryLabel
        lbl_comment_counter.textColor = UIColor.secondaryLabel
        lbl_reply_message.textColor = UINCColor.error
        
        tbl_comment.delegate = self
        tbl_comment.dataSource = self
        tbl_comment.register(CommentCell.source.nib, forCellReuseIdentifier: CommentCell.source.identifier)
        tbl_comment.refreshControl = refreshControl
//        refreshControl.addTarget(self, action: #selector(self.didRefresh()), for: .valueChanged)
        
        let validations: [ValidationType] = [.isNotBlank, .isGreaterThanOrEqual5]
        input_reply.sendButton.onTextViewDidChange { [weak self] (input_item, txt_view) in
            for validation in validations {
                let valid = validation.isValid(txt_view.text)
                if valid.isSuccess {
                    self?.presenter?.set(text_content: txt_view.text)
                    self?.lbl_reply_message.isHidden = true
                } else {
                    self?.lbl_reply_message.isHidden = false
                    self?.lbl_reply_message.text = valid.error
                }
            }
        }
        
        input_reply.sendButton.onTouchUpInside({ [weak self] (inputItem) in
            self?.presenter?.didClickNewComment()
            self?.input_reply.inputTextView.text = nil
        })
        
        stack_container.addArrangedSubview(input_reply)
    }
    
    @objc func didRefresh() {
        presenter?.didRequestComments()
    }
    
    func updateUI(data: TimelineItems) {
        if let username = data.user?.name {
            image_profile.setImageForName(string: username, circular: true)
            lbl_username.text = username
        }
        
        if let url_avatar = URL(string: data.user?.avatar ?? "") {
            image_profile.circleCorner = true
            image_profile.kf.setImage(with: url_avatar)
        }
        
        lbl_time.text = data.created_at.toDate(format: "yyyy-MM-dd HH:mm:ss")?.timeAgo(numericDates: true)
        lbl_textcontent.text = data.text_content
        lbl_like_counter.text = data.total_likes > 1 ? "\(data.total_likes) likes" : "\(data.total_likes) like"
        lbl_comment_counter.text = data.total_comments > 1 ? "\(data.total_comments) replies" : "\(data.total_comments) reply"
    }
    
    func reloadComments() {
        tbl_comment.reloadData()
    }
    
    func showFailMessage(title: String, message: String) {
        showAlert(title: title, message: message) { actionOK in
            //
        } CancelCompletion: { actionCancel in
            //
        }

    }
    
    func startLoader() {
        showLoaderIndicator()
    }
    
    func stopLoader() {
        dismissLoaderIndicator()
    }
}

extension CommentView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfRowsInSection() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let isLastItem = indexPath.row + 1 == presenter?.numberOfRowsInSection()
        
//        if isLastItem && commentsApi?.next_page != 999 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingTableViewCell") as! LoadingTableViewCell
//            cell.ActIndicatorLoading.startAnimating()
//            return cell
//        }

        if let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.source.identifier) as? CommentCell {
            cell.comment = presenter?.cellForRowAt(index: indexPath.row)
            return cell
        }
        
        return UITableViewCell()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height {
            presenter?.didRequestComments()
        }
    }
}
