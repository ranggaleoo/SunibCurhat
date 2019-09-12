//
//  ListCurhatViewController.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 04/08/19.
//  Copyright © 2019 Rangga Leo. All rights reserved.
//

import Foundation
import UIKit

class ListCurhatViewController: UIViewController {
    
    @IBOutlet weak var tableViewCurhat: UITableView!
    
    private lazy var refreshControl: UIRefreshControl = {
        let r = UIRefreshControl()
        r.tintColor = UIColor.custom.gray
        r.attributedTitle = NSAttributedString(string: "Fetching timeline..", attributes: [NSAttributedString.Key.font: UIFont.custom.regular.size(of: 12)])
        return r
    }()
    
    var timelineApi: TimelineResponse?
    var timeline: [TimelineItems] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableViewCurhat.reloadData()
            }
        }
    }
    
    var fromAddThread: Bool = false
    var indexBeforeToComment: IndexPath?
    var getTimelineMore: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegates()
        getTimeline()
    }
    
    private func delegates() {
        self.title = "Timeline"
        self.setupMenuBarButtonItem()
        tableViewCurhat.delegate = self
        tableViewCurhat.dataSource = self
        
        if #available(iOS 10.0, *) {
            tableViewCurhat.refreshControl = refreshControl
        } else {
            tableViewCurhat.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(getTimeline), for: .valueChanged)
    }
    
    func moveFromAddThread() {
        DispatchQueue.main.async {
            self.fromAddThread = true
            self.getTimeline()
        }
    }
    
    @objc func getTimeline() {
        guard !getTimelineMore else {
            return
        }
        getTimelineMore = true
        
        if refreshControl.isRefreshing || fromAddThread {
            timelineApi = nil
            timeline.removeAll()
        }
        
        let page = timelineApi?.next_page ?? 1
        if page == 999 {
            self.getTimelineMore = false
            return
        }
        
        TimelineService.shared.getTimeline(page: page) { (result) in
            DispatchQueue.main.async {
                if self.refreshControl.isRefreshing {
                    self.refreshControl.endRefreshing()
                }
            }
            switch result {
            case .failure(let error):
                self.showAlert(title: "Error", message: error.localizedDescription + "\n Update Session?", OKcompletion: { (act) in
                    self.getTimelineMore = false
                    RepoMemory.token = nil
                    RepoMemory.pendingFunction = self.getTimeline.self
                }, CancelCompletion: nil)
                
                print(error)
            case .success(let success):
                self.fromAddThread = false
                if success.success {
                    if let data = success.data {
                        self.getTimelineMore = false
                        self.timelineApi = data
                        self.timeline.append(data.timelines)
                    }
                
                } else {
                    self.getTimelineMore = false
                    print(success.message)
                }
            }
        }
    }
    
    @objc func likeTimeline(timeline_id: Int, cell: CurhatTableViewCell) {
//        self.showLoaderIndicator()
        cell.isLiked = true
        cell.btn_likes.isEnabled = false
        TimelineService.shared.likeTimeline(timeline_id: timeline_id) { (result) in
            switch result {
            case .failure(let e):
//                self.dismissLoaderIndicator()
                cell.btn_likes.isEnabled = true
                self.showAlert(title: "Error", message: e.localizedDescription + "\n Update Session?", OKcompletion: { (act) in
                    RepoMemory.token = nil
                }, CancelCompletion: nil)
                
            case .success(let s):
//                self.dismissLoaderIndicator()
                cell.btn_likes.isEnabled = true
                if s.success {
                    cell.isLiked = true
                } else {
                    self.showAlert(title: "Error", message: s.message + "\n Try Again?", OKcompletion: { (act) in
                        self.likeTimeline(timeline_id: timeline_id, cell: cell)
                    }, CancelCompletion: nil)
                }
            }
        }
    }
    
    @objc func unlikeTimeline(timeline_id: Int, cell: CurhatTableViewCell) {
//        self.showLoaderIndicator()
        cell.isLiked = false
        cell.btn_likes.isEnabled = false
        TimelineService.shared.unlikeTimeline(timeline_id: timeline_id) { (result) in
            switch result {
            case .failure(let e):
//                self.dismissLoaderIndicator()
                cell.btn_likes.isEnabled = true
                self.showAlert(title: "Error", message: e.localizedDescription + "\n Update Session?", OKcompletion: { (act) in
                    RepoMemory.token = nil
                }, CancelCompletion: nil)
                
            case .success(let s):
//                self.dismissLoaderIndicator()
                cell.btn_likes.isEnabled = true
                if s.success {
                    cell.isLiked = false
                } else {
                    self.showAlert(title: "Error", message: s.message + "\n Try Again?", OKcompletion: { (act) in
                        self.unlikeTimeline(timeline_id: timeline_id, cell: cell)
                    }, CancelCompletion: nil)
                }
            }
        }
    }
    
    @objc func shareTimeline(timeline_id: Int) {
        self.showLoaderIndicator()
        TimelineService.shared.shareTimeline(timeline_id: timeline_id) { (result) in
            switch result {
            case .failure(let e):
                self.dismissLoaderIndicator()
                self.showAlert(title: "Error", message: e.localizedDescription, OKcompletion: { (act) in
                    RepoMemory.token = nil
                }, CancelCompletion: nil)
                
            case .success(let s):
                self.dismissLoaderIndicator()
                if s.success {
                    //
                } else {
                    self.showAlert(title: "Error", message: s.message, OKcompletion: nil, CancelCompletion: nil)
                }
            }
        }
    }
    
    @objc func deleteTimeline(timeline_id: Int, indexPath: IndexPath) {
//        self.showLoaderIndicator()
        print("----- delete", timeline_id)
        self.timeline.remove(at: indexPath.row)
        self.tableViewCurhat.deleteRows(at: [indexPath], with: .left)
        TimelineService.shared.deleteTimeline(timeline_id: timeline_id, completion: { (result) in
            switch result {
            case .failure(let e):
//                self.dismissLoaderIndicator()
                self.showAlert(title: "Error", message: e.localizedDescription, OKcompletion: { (act) in
                    RepoMemory.token = nil
                }, CancelCompletion: nil)
                
            case .success(let s):
                self.dismissLoaderIndicator()
                if s.success {
                    //
                } else {
                    print(s.message);
                }
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "toComment":
            let d = segue.destination as! CommentCurhatViewController
            if let index = indexBeforeToComment?.row {
                d.timeline = self.timeline[index]
            }
            
        case "toReport":
            let d = segue.destination as! ReportViewController
            if let index = indexBeforeToComment?.row {
                d.timeline = self.timeline[index]
            }
            
        default:
            print(segue.identifier, "not found")
        }
    }
}

extension ListCurhatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeline.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let isLastItem = indexPath.row + 1 == timeline.count
        
        if isLastItem && timelineApi?.next_page != 999 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingTableViewCell") as! LoadingTableViewCell
            cell.ActIndicatorLoading.startAnimating()
            return cell
        }
        
        if timeline[indexPath.row].is_ads {
            if
                let ads_type = timeline[indexPath.row].ads_type,
                ads_type == "google"
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "GADBannerTableViewCell") as! GADBannerTableViewCell
                cell.root = self
                cell.timeline = timeline[indexPath.row]
                return cell
                
            } else if
                let ads_type = timeline[indexPath.row].ads_type,
                ads_type == "sunib"
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AdsTableViewCell") as! AdsTableViewCell
                cell.timeline = timeline[indexPath.row]
                return cell
            }
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurhatTableViewCell") as! CurhatTableViewCell
        cell.timeline = timeline[indexPath.row]
        
        cell.btn_likes_clicked = { (btn) in
            let timeline_id = self.timeline[indexPath.row].timeline_id
            let isLiked = cell.isLiked
            if isLiked {
                self.unlikeTimeline(timeline_id: timeline_id, cell: cell)
            } else {
                self.likeTimeline(timeline_id: timeline_id, cell: cell)
            }
        }
        
        cell.btn_shares_clicked = { (btn) in
            let timeline_id = self.timeline[indexPath.row].timeline_id
            let shareText = self.timeline[indexPath.row].text_content + " - " + self.timeline[indexPath.row].name
            let vc = UIActivityViewController(activityItems: [shareText], applicationActivities: [])
            vc.completionWithItemsHandler = { (actType: UIActivity.ActivityType?, completed: Bool, returnItems: [Any]?, error: Error?) in
                if completed {
                    self.shareTimeline(timeline_id: timeline_id)
                }
            }
            self.present(vc, animated: true)
        }
        
        cell.btn_comments_clicked = { (btn) in
            self.indexBeforeToComment = indexPath
            self.performSegue(withIdentifier: "toComment", sender: self)
        }
        
        cell.btn_more_clicked = { (btn) in
            let alert = UIAlertController(title: "More", message: nil, preferredStyle: .actionSheet)
            
            if self.timeline[indexPath.row].device_id == RepoMemory.device_id {
                alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (act) in
                    self.deleteTimeline(timeline_id: self.timeline[indexPath.row].timeline_id, indexPath: indexPath)
                }))
            }
            
            alert.addAction(UIAlertAction(title: "Send Chat", style: .default, handler: { (act) in
                if let vc = self.tabBarController?.viewControllers {
                    guard let navigationController = vc[2] as? UINavigationController else { return }
                    if let c = navigationController.topViewController as? ChatsViewController {
                        let myDeviceId          = RepoMemory.device_id
                        let strangerDeviceId    = self.timeline[indexPath.row].device_id
                        
                        guard myDeviceId != strangerDeviceId else {
                            self.showAlert(title: "Error", message: "You cannot chat yourself", OKcompletion: nil, CancelCompletion: nil)
                            return
                        }
                        
                        self.tabBarController?.selectedIndex = 2
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                            let chat_id = myDeviceId + "+" + strangerDeviceId
                            let name = self.timeline[indexPath.row].name
                            let users = [myDeviceId, strangerDeviceId]
                            c.createChatRoom(chat_id: chat_id, name: name, users: users)
                        })
                    }
                }
            }))
            
            alert.addAction(UIAlertAction(title: "Report", style: .destructive, handler: { (act) in
                self.indexBeforeToComment = indexPath
                self.performSegue(withIdentifier: "toReport", sender: self)
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.indexBeforeToComment = indexPath
        self.performSegue(withIdentifier: "toComment", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height {
            if !getTimelineMore {
                self.getTimeline()
            }
        }
    }
}
