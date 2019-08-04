//
//  CurhatTableViewCell.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 04/08/19.
//  Copyright © 2019 Rangga Leo. All rights reserved.
//

import Foundation
import UIKit

class CurhatTableViewCell: UITableViewCell {
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_curhat: UILabel!
    @IBOutlet weak var lbl_count_likes: UILabel!
    @IBOutlet weak var lbl_count_comments: UILabel!
    @IBOutlet weak var lbl_count_shares: UILabel!
    @IBOutlet weak var lbl_time: UILabel!
    @IBOutlet weak var btn_likes: UIButton!
    
    var btn_likes_clicked: ((UIButton) -> Void)?
    var btn_comments_clicked: ((UIButton) -> Void)?
    var btn_shares_clicked: ((UIButton) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    private func updateUI() {
        
    }
    
    @IBAction private func actionLike(_ sender: UIButton) {
        btn_likes_clicked?(sender)
    }
    
    @IBAction private func actionComment(_ sender: UIButton) {
        btn_comments_clicked?(sender)
    }
    
    @IBAction private func actionShare(_ sender: UIButton) {
        btn_shares_clicked?(sender)
    }
    
}
