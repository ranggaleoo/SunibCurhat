//
//  CommentTableViewCell.swift
//  SunibCurhat
//
//  Created by Koinworks on 8/22/19.
//  Copyright © 2019 Rangga Leo. All rights reserved.
//

import Foundation
import UIKit

class CommentTableViewCell: UITableViewCell {
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_comment: UILabel!
    @IBOutlet weak var lbl_time: UILabel!
    
    var comment: CommentResponse? {
        didSet {
            self.updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    private func updateUI() {
        DispatchQueue.main.async {
            self.lbl_name.text = self.comment?.name
            self.lbl_comment.text = self.comment?.text_content
            self.lbl_time.text = self.comment?.timed
        }
    }
}
