//
//  AdsTableViewCell.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 04/08/19.
//  Copyright © 2019 Rangga Leo. All rights reserved.
//

import Foundation
import UIKit

class AdsTableViewCell: UITableViewCell {
    @IBOutlet weak var imageViewAds: UIImageView!
    
    var timeline: TimelineItems? {
        didSet {
            self.updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    private func updateUI() {
        self.imageViewAds.contentMode = .scaleAspectFit
        self.contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.actionOpenAds)))
        DispatchQueue.global().async {
            self.imageViewAds.downloaded(urlString: self.timeline?.ad_url_media ?? "")
        }
    }
    
    @objc private func actionOpenAds() {
        if let url = URL(string: timeline?.ad_url_action ?? "") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:]) { (clicked) in
                    if clicked {
                        guard
                            let ad_unit_id_string = self.timeline?.ad_unit_id,
                            let ad_unit_id = Int(ad_unit_id_string)
                            else {
                                return
                        }
                        MainService.shared.adsClicked(ad_unit_id: ad_unit_id, completion: { (result) in
                            switch result {
                            case .failure(let e):
                                RepoMemory.token = nil
                                RepoMemory.pendingFunction = self.actionOpenAds.self
                                debugLog(e.localizedDescription)
                            case .success(let s):
                                debugLog(s)
                            }
                        })
                    }
                }
            } else {
                debugLog("---- cannot open link")
            }
        }
    }
}
