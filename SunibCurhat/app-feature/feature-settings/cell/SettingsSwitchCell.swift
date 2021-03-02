//
//  SettingsSwitchCell.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 02/03/21.
//  Copyright © 2021 Rangga Leo. All rights reserved.
//

import UIKit

enum SettingItemType: CaseIterable {
    case pushNotification
}

struct SettingItem: Codable {
    let title: String
    let type: SettingItemType
    let defaultValue: Bool
    var usersValue: Bool?
}

class SettingsSwitchCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UINCLabelBody!
    @IBOutlet weak var switcher: UINCSwitchDefault!
    
    var item: SettingItem? {
        didSet {
            updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    private func setupViews() {
        
    }
    
    private func updateUI() {
        lblTitle.text = item?.title
        switcher.setOn(item?.usersValue ?? item?.defaultValue ?? false, animated: false)
    }
}
