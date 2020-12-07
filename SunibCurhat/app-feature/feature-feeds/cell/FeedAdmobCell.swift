//
//  FeedAdmobCell.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 01/12/20.
//  Copyright © 2020 Rangga Leo. All rights reserved.
//

import UIKit
import GoogleMobileAds

protocol FeedAdmobCellDelegate: class {
    func didTapRemoveAds(cell: FeedAdmobCell)
    func didReceivedAd(cell: FeedAdmobCell)
}

class FeedAdmobCell: UITableViewCell {
    
    @IBOutlet weak var btn_remove: UINCButtonPrimaryRounded!
    @IBOutlet weak var ads_view: GADBannerView!
    var root: UIViewController?
    
    struct source {
        static var nib: UINib = UINib(nibName: String(describing: FeedAdmobCell.self), bundle: Bundle(for: FeedAdmobCell.self))
        static var identifier: String = String(describing: FeedAdmobCell.self)
    }
    
    var timeline: TimelineItems? {
        didSet {
            self.updateUI()
        }
    }
    
    weak var delegate: FeedAdmobCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    private func setupViews() {
        selectionStyle = .none
        ads_view.delegate = self
        btn_remove.setTitle("Remove Ads FOREVER!", for: .normal)
        btn_remove.addTarget(self, action: #selector(actionRemoveAds(_:)), for: .touchUpInside)
    }
    
    private func updateUI() {
        if UDHelpers.shared.getBool(key: .isFreeAds) {
            btn_remove.isHidden = true
            ads_view.isHidden = true
        } else {
            ads_view.adUnitID = self.timeline?.ad_unit_id
            ads_view.rootViewController = root
            ads_view.load(GADRequest())
        }
    }
    
    @objc func actionRemoveAds(_ sender: UIButton) {
        delegate?.didTapRemoveAds(cell: self)
    }
}

extension FeedAdmobCell: GADBannerViewDelegate {
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        delegate?.didReceivedAd(cell: self)
    }
}
