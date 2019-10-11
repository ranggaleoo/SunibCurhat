//
//  PremiumSubscriptionTableViewCell.swift
//  SunibCurhat
//
//  Created by Koinworks on 10/11/19.
//  Copyright © 2019 Rangga Leo. All rights reserved.
//

import Foundation
import UIKit

class PremiumSubscriptionTableViewCell: UITableViewCell {
    @IBOutlet weak var imageViewSubs    : UIImageView!
    @IBOutlet weak var lbl_price        : UILabel!
    @IBOutlet weak var lbl_type         : UILabel!
    
    var subscription: SubscriptionPremiumUserResponse? {
        didSet {
            self.updateUI()
        }
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func updateUI() {
        self.imageViewSubs.downloaded(urlString: subscription?.image ?? "")
        self.lbl_price.text = "\(subscription?.price ?? 1)"
        self.lbl_type.text  = subscription?.type
    }
}
