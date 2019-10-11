//
//  PremiumAdvantageCollectionViewCell.swift
//  SunibCurhat
//
//  Created by Koinworks on 10/11/19.
//  Copyright © 2019 Rangga Leo. All rights reserved.
//

import Foundation
import UIKit

class PremiumAdvantageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView    : UIImageView!
    @IBOutlet weak var lbl_title    : UILabel!
    @IBOutlet weak var lbl_content  : UILabel!
    
    var advantage: AdvantagePremiumUserResponse? {
        didSet {
            self.UpdateUI()
        }
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func UpdateUI() {
        self.imageView.downloaded(urlString: advantage?.image ?? "")
        self.lbl_title.text     = self.advantage?.name
        self.lbl_content.text   = self.advantage?.content
    }
}
