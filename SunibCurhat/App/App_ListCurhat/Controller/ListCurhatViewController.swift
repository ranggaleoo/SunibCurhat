//
//  ListCurhatViewController.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 04/08/19.
//  Copyright © 2019 Rangga Leo. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

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
    
    func setupMenuBarButtonItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "bar_btn_more_vert"), style: .plain, target: self, action: #selector(actionMenuBarButtonItem))
    }
    
    @objc private func actionMenuBarButtonItem(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Menu", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Contact Us", style: .default, handler: { (act) in
            let alert2 = UIAlertController(title: "Contact Us", message: nil, preferredStyle: .actionSheet)
            
            alert2.addAction(UIAlertAction(title: "Email", style: .default, handler: { (act) in
                if MFMailComposeViewController.canSendMail() {
                    let mail = MFMailComposeViewController()
                    mail.mailComposeDelegate = self
                    mail.setToRecipients([ConstGlobal.contact_email ?? "noreplyhere@hi2.in"])
                    mail.setSubject(ConstGlobal.app_name ?? "Subject")
                    mail.setMessageBody("<p>Hi \(ConstGlobal.app_name ?? "")</p>", isHTML: true)
                    
                    self.present(mail, animated: true)
                } else {
                    // show failure alert
                }
            }))
            
            alert2.addAction(UIAlertAction(title: "Instagram", style: .default, handler: { (act) in
                guard let url = URL(string: "https://www.instagram.com/\(ConstGlobal.contact_instagram ?? "instagram")/") else {return}
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                        if success {
                            print("----- open instagram")
                        }
                    })
                }
            }))
            
            alert2.addAction(UIAlertAction(title: "Whatsapp", style: .default, handler: { (act) in
                guard let url = URL(string: "https://api.whatsapp.com/send?phone=\(ConstGlobal.contact_whatsapp ?? "")&text=Halo%20\(ConstGlobal.app_name ?? "")") else {return}
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                        if success {
                            print("----- open whatsapp")
                        }
                    })
                }
            }))
            
            alert2.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert2, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Privacy Policy", style: .default, handler: { (act) in
            guard let url_privacy = URL(string: "https://bit.ly/privacypolicesunib") else {return}
            if UIApplication.shared.canOpenURL(url_privacy) {
                UIApplication.shared.open(url_privacy, options: [:], completionHandler: { (success) in
                    if success {
                        print("----- open privacy policy")
                    }
                })
            }
        }))
        
        alert.addAction(UIAlertAction(title: "User Agreement", style: .default, handler: { (act) in
            guard let url_eula = URL(string: "https://bit.ly/uelasunibcurhat") else {return}
            if UIApplication.shared.canOpenURL(url_eula) {
                UIApplication.shared.open(url_eula, options: [:], completionHandler: { (success) in
                    if success {
                        print("----- user agreement")
                    }
                })
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
