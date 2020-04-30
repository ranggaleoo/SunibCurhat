//
//  Timeline+TableView.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 21/09/19.
//  Copyright © 2019 Rangga Leo. All rights reserved.
//

import Foundation
import UIKit

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
                ads_type == "app"
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
