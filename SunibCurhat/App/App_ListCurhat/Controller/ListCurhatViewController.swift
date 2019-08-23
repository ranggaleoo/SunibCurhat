//
//  ListCurhatViewController.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 04/08/19.
//  Copyright © 2019 Rangga Leo. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds

class ListCurhatViewController: UIViewController {
    
    @IBOutlet weak var tableViewCurhat: UITableView!
    @IBOutlet weak var admob_unit_1: GADBannerView!
    
    private lazy var refreshControl: UIRefreshControl = {
        let r = UIRefreshControl()
        r.tintColor = UIColor.custom.gray
        r.attributedTitle = NSAttributedString(string: "Fetching timeline..", attributes: [NSAttributedString.Key.font: UIFont.custom.regular.size(of: 12)])
        return r
    }()
    
    var timeline: [TimelineResponse] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableViewCurhat.reloadData()
            }
        }
    }
    
    var indexBeforeToComment: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegates()
        configAdUnit()
        getTimeline()
    }
    
    private func delegates() {
        self.title = "Timeline"
        tableViewCurhat.delegate = self
        tableViewCurhat.dataSource = self
        
        if #available(iOS 10.0, *) {
            tableViewCurhat.refreshControl = refreshControl
        } else {
            tableViewCurhat.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(getTimeline), for: .valueChanged)
    }
    
    private func configAdUnit() {
        admob_unit_1.delegate = self
        admob_unit_1.alpha = 0
        admob_unit_1.adUnitID = ConstGlobal.AdMOB_UNIT_ID_TEST_BANNER
        admob_unit_1.rootViewController = self
        admob_unit_1.load(GADRequest())
    }
    
    @objc func getTimeline() {
        if !refreshControl.isRefreshing {
            self.showLoaderIndicator()
        }
        
        TimelineService.shared.getTimeline { (result) in
            switch result {
            case .failure(let error):
                self.dismissLoaderIndicator()
                self.refreshControl.endRefreshing()
                self.showAlert(title: "Error", message: error.localizedDescription + "\n Update Session?", OKcompletion: { (act) in
                    RepoMemory.token = nil
                    RepoMemory.pendingFunction = self.getTimeline.self
                }, CancelCompletion: nil)
                
                print(error)
            case .success(let success):
                self.dismissLoaderIndicator()
                self.refreshControl.endRefreshing()
                if success.success {
                    if let data = success.data {
                        self.timeline = data
                    }
                
                } else {
                    print(success.message)
                }
            }
        }
    }
    
    @objc func likeTimeline(timeline_id: Int, cell: CurhatTableViewCell) {
        self.showLoaderIndicator()
        TimelineService.shared.likeTimeline(timeline_id: timeline_id) { (result) in
            switch result {
            case .failure(let e):
                self.dismissLoaderIndicator()
                self.showAlert(title: "Error", message: e.localizedDescription + "\n Update Session?", OKcompletion: { (act) in
                    RepoMemory.token = nil
                }, CancelCompletion: nil)
                
            case .success(let s):
                self.dismissLoaderIndicator()
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
        self.showLoaderIndicator()
        TimelineService.shared.unlikeTimeline(timeline_id: timeline_id) { (result) in
            switch result {
            case .failure(let e):
                self.dismissLoaderIndicator()
                self.showAlert(title: "Error", message: e.localizedDescription + "\n Update Session?", OKcompletion: { (act) in
                    RepoMemory.token = nil
                }, CancelCompletion: nil)
                
            case .success(let s):
                self.dismissLoaderIndicator()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "toComment":
            let d = segue.destination as! CommentCurhatViewController
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurhatTableViewCell") as! CurhatTableViewCell
        cell.timeline = timeline[indexPath.row]
        cell.isLiked = false
        
        cell.btn_likes_clicked = { (btn) in
            guard let timeline_id = Int(self.timeline[indexPath.row].timeline_id) else {return}
            let isLiked = cell.isLiked
            if isLiked {
                self.unlikeTimeline(timeline_id: timeline_id, cell: cell)
            } else {
                self.likeTimeline(timeline_id: timeline_id, cell: cell)
            }
        }
        
        cell.btn_shares_clicked = { (btn) in
            guard let timeline_id = Int(self.timeline[indexPath.row].timeline_id) else {return}
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.indexBeforeToComment = indexPath
        self.performSegue(withIdentifier: "toComment", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension ListCurhatViewController: GADBannerViewDelegate {
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        admob_unit_1.alpha = 0
        UIView.animate(withDuration: 1) {
            self.admob_unit_1.alpha = 1
        }
        print_r(title: "ADMOB RECEIVE", message: nil)
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print_r(title: "ADMOB ERROR", message: error)
    }
    
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print_r(title: "ADMOB WILL PRESENT", message: nil)
    }
    
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print_r(title: "ADMOB WILL DISMISS", message: nil)
    }
    
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print_r(title: "ADMOB DID DISMISS", message: nil)
    }
    
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print_r(title: "ADMOB WILL LEAVE", message: nil)
    }
}
