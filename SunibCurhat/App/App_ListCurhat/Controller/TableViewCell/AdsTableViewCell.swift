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
    @IBOutlet weak var lbl_name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    private func updateUI() {
        
    }
}
