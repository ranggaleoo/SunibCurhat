//
//  CommentCurhatViewController.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 04/08/19.
//  Copyright © 2019 Rangga Leo. All rights reserved.
//

import Foundation
import UIKit
//import GoogleMobileAds

class CommentCurhatViewController: UIViewController {
    @IBOutlet weak var tableViewComment: UITableView!
    @IBOutlet weak var scrollViewComment: UIScrollView!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_text_content: UILabel!
    @IBOutlet weak var lbl_time: UILabel!
    @IBOutlet weak var txt_comment: UITextView!
//    @IBOutlet weak var bannerView: GADBannerView!
    
    private lazy var refreshControl: UIRefreshControl = {
        let r = UIRefreshControl()
        r.tintColor = UIColor.custom.gray
        r.attributedTitle = NSAttributedString(string: "Fetching comments..", attributes: [NSAttributedString.Key.font: UIFont.custom.regular.size(of: 12)])
        return r
    }()
    
    var commentsApi: CommentResponse?
    var comments: [CommentItems] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableViewComment.reloadData()
            }
        }
    }
    var getMoreComment: Bool = false
    var timeline: TimelineItems?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegates()
        updateUI()
        configAdUI()
    }
    
    private func updateUI() {
        DispatchQueue.main.async {
            self.lbl_name.text = self.timeline?.name
            self.lbl_text_content.text = self.timeline?.text_content
            self.lbl_time.text = self.timeline?.timed.toDate(format: "yyyy-MM-dd HH:mm:ss")?.timeAgo(numericDates: true)
        }
    }
    
    private func configAdUI() {
        if UDHelpers.shared.getBool(key: .isFreeAds) {
//            bannerView.isHidden = true
        }
//        bannerView.isHidden = true
        MainService.shared.getAdBannerUnitID { (result) in
            switch result {
            case .failure(let e):
                debugLog(e.localizedDescription)
            case .success(let s):
                if s.success {
                    if let ad_unit_id = s.data {
//                        self.bannerView.delegate = self
//                        self.bannerView.adUnitID = ad_unit_id
//                        self.bannerView.rootViewController = self
//                        self.bannerView.load(GADRequest())
                    }
                }
            }
        }
    }
    
    private func delegates() {
        self.title = "Comment"
        tableViewComment.delegate = self
        tableViewComment.dataSource = self
        txt_comment.delegate = self
        txt_comment.isScrollEnabled = false
        txt_comment.text = "Enter a comment?"
        txt_comment.textColor = UIColor.custom.gray
        textViewDidChange(txt_comment)
        self.endEditing()
        getComments()
        
        if #available(iOS 10.0, *) {
            tableViewComment.refreshControl = refreshControl
        } else {
            tableViewComment.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(getComments), for: .valueChanged)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @IBAction func actionSend(_ sender: UIButton) {
        addComment()
    }
    
    @objc func keyboardWillShow(notification: NSNotification){
        let userInfo      = notification.userInfo!
        var keyboardFrame = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        var contentInset:UIEdgeInsets = self.scrollViewComment.contentInset
        contentInset.bottom = keyboardFrame.size.height + 20
        scrollViewComment.contentInset = contentInset
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        let userInfo      = notification.userInfo!
        var keyboardFrame = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        var contentInset:UIEdgeInsets = self.scrollViewComment.contentInset
        contentInset.bottom = 0.0
        scrollViewComment.contentInset = contentInset
    }
    
    @objc func addComment() {
        guard txt_comment.textColor != UIColor.custom.gray_absolute && txt_comment.text.count > ConstGlobal.MINIMUM_TEXT else {
            self.showAlert(title: "Error", message: "Write your comment, at least \(ConstGlobal.MINIMUM_TEXT) character", OKcompletion: nil, CancelCompletion: nil)
            return
        }
        
        guard let timeline_id = timeline?.timeline_id else { return }
        
        self.showLoaderIndicator()
        CommentService.shared.addComment(timeline_id: timeline_id, text_content: txt_comment.text) { (result) in
            switch result {
            case .failure(let e):
                self.dismissLoaderIndicator()
                if e.localizedDescription.contains("403") {
                    RepoMemory.token = nil
                    RepoMemory.pendingFunction = self.addComment.self
                } else {
                    self.showAlert(title: "Error", message: e.localizedDescription, OKcompletion: nil, CancelCompletion: nil)
                }
                
            case .success(let s):
                self.dismissLoaderIndicator()
                if s.success {
                    self.txt_comment.text = ""
                    self.textViewDidChange(self.txt_comment)
                    self.refreshControl.beginRefreshing()
                } else {
                    self.showAlert(title: "Error", message: s.message + "\n Try Again?", OKcompletion: { (act) in
                        self.addComment()
                    }, CancelCompletion: nil)
                }
            }
        }
    }
    
    @objc func deleteComment(comment_id: String, indexPath: IndexPath) {
        debugLog("----- delete", comment_id)
        self.comments.remove(at: indexPath.row)
        self.tableViewComment.deleteRows(at: [indexPath], with: .left)
        CommentService.shared.deleteComment(comment_id: comment_id, completion: { (result) in
            switch result {
            case .failure(let e):
                self.showAlert(title: "Error", message: e.localizedDescription, OKcompletion: { (act) in
                    RepoMemory.token = nil
                }, CancelCompletion: nil)
                
            case .success(let s):
                if s.success {
                    //do nothing
                } else {
                    debugLog(s.message);
                }
            }
        })
    }
    
    @objc func getComments() {
        guard
            !getMoreComment,
            let timeline_id = timeline?.timeline_id
            else {
                return
        }
        
        getMoreComment = true
        
        if refreshControl.isRefreshing {
            commentsApi = nil
            comments.removeAll()
        }
        
        let page = commentsApi?.next_page ?? 1
        if page == 999 {
            self.getMoreComment = false
            return
        }
        
        CommentService.shared.getComments(page: page, timeline_id: timeline_id) { (result) in
            switch result {
            case .failure(let e):
                self.refreshControl.endRefreshing()
                if e.localizedDescription.contains("403") {
                    self.getMoreComment = false
                    RepoMemory.token = nil
                    RepoMemory.pendingFunction = self.getComments.self
                } else {
                    self.showAlert(title: "Error", message: e.localizedDescription, OKcompletion: nil, CancelCompletion: nil)
                }
                
            case .success(let s):
                self.refreshControl.endRefreshing()
                if s.success {
                    if let data = s.data {
                        self.getMoreComment = false
                        self.comments.append(data.comments)
                        self.commentsApi = data
                    }
                
                } else {
                    self.getMoreComment = false
                    debugLog(s.message)
                }
            }
        }
    }
}

extension CommentCurhatViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: self.view.frame.width - 32, height: .infinity)
        let estimateSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach { (cs) in
            if cs.firstAttribute == .height {
                DispatchQueue.main.async {
                    cs.constant = estimateSize.height
                }
            }
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.custom.gray {
            textView.text = nil
            textView.textColor = UIColor.white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter a comment?"
            textView.textColor = UIColor.custom.gray_absolute
        }
    }
}

extension CommentCurhatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let isLastItem = indexPath.row + 1 == comments.count
        
        if isLastItem && commentsApi?.next_page != 999 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingTableViewCell") as! LoadingTableViewCell
            cell.ActIndicatorLoading.startAnimating()
            return cell
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell") as! CommentTableViewCell
        cell.comment = comments[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        var buttons: [UITableViewRowAction] = []
        let sendChatButton = UITableViewRowAction(style: .normal, title: "Chat") { (action, index) in
            if let vc = self.tabBarController?.viewControllers {
                guard let navigationController = vc[1] as? UINavigationController else { return }
                if let c = navigationController.topViewController as? ChatsViewController {
                    let myDeviceId          = RepoMemory.device_id
                    let strangerDeviceId    = self.comments[index.row].device_id
                    
                    guard myDeviceId != strangerDeviceId else {
                        self.showAlert(title: "Error", message: "You cannot chat yourself", OKcompletion: nil, CancelCompletion: nil)
                        return
                    }
                    
                    self.tabBarController?.selectedIndex = 1
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        let chat_id = myDeviceId + "+" + strangerDeviceId
                        let name = self.comments[index.row].name
                        let users = [myDeviceId, strangerDeviceId]
                        c.createChatRoom(chat_id: chat_id, name: name, users: users)
                    })
                }
            }
        }
        
        let deleteButton = UITableViewRowAction(style: .normal, title: "Delete") { (action, indexPath) in
            self.deleteComment(comment_id: "\(self.comments[indexPath.row].comment_id)", indexPath: indexPath)
        }
        if comments[indexPath.row].device_id != RepoMemory.device_id {
            sendChatButton.backgroundColor = UIColor.custom.blue
            buttons.append(sendChatButton)
        
        } else {
            deleteButton.backgroundColor = UIColor.custom.red_absolute
            buttons.append(deleteButton)
        }
        
        return buttons
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height {
            if !getMoreComment {
                self.getComments()
            }
        }
    }
    
}

//extension CommentCurhatViewController: GADBannerViewDelegate {
//    // request lifecycle
//    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
//        debugLog(#function)
//    }
//    
//    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
//        debugLog(#function)
//    }
//    
//    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
//        debugLog(#function)
//    }
//    
//    //click-time lifecycle
//    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
//        debugLog(#function)
//    }
//    
//    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
//        debugLog(#function)
//    }
//    
//    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
//        debugLog(#function)
//    }
//}
