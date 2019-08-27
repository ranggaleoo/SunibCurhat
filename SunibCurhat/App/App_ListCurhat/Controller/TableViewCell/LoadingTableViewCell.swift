//
//  LoadingTableViewCell.swift
//  SunibCurhat
//
//  Created by Koinworks on 8/27/19.
//  Copyright © 2019 Rangga Leo. All rights reserved.
//

import Foundation
import UIKit

class LoadingTableViewCell: UITableViewCell {
    @IBOutlet weak var ActIndicatorLoading: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
}
