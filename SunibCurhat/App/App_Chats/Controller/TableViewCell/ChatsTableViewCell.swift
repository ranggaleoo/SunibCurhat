//
//  ChatsTableViewCell.swift
//  SunibCurhat
//
//  Created by Koinworks on 8/28/19.
//  Copyright © 2019 Rangga Leo. All rights reserved.
//

import Foundation
import UIKit

class ChatsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbl_name             : UILabel!
//    @IBOutlet weak var lbl_message          : UILabel!
//    @IBOutlet weak var lbl_timed            : UILabel!
//    @IBOutlet weak var lbl_count_message    : UILabel!
    
    var chat: Chat? {
        didSet {
            self.updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle  = .none
        accessoryType   = .disclosureIndicator
    }
    
    private func updateUI() {
        DispatchQueue.main.async {
            self.lbl_name.text = self.chat?.name
        }
    }
}
