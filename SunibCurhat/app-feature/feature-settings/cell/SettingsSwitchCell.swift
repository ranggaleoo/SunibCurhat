//
//  SettingsSwitchCell.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 02/03/21.
//  Copyright © 2021 Rangga Leo. All rights reserved.
//

import UIKit

enum SettingItemType: String, Codable, CaseIterable {
    case pushNotification
}

struct SettingItem: Codable, Equatable {
    let title: String
    let description: String?
    let type: SettingItemType
    let defaultValue: Bool
    var usersValue: Bool?
    
    static func == (lhs: SettingItem, rhs: SettingItem) -> Bool {
        return lhs.title == rhs.title
            && lhs.description == rhs.description
            && lhs.type == rhs.type
    }
}

typealias SettingList = [SettingItem]

extension SettingList {
    func get(_ type: SettingItemType) -> SettingItem? {
        self.first(where: { $0.type == type })
    }
}

protocol SettingsSwitchCellDelegate: class {
    func didChangeSwitchState(cell: SettingsSwitchCell, isOn: Bool)
}

class SettingsSwitchCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UINCLabelBody!
    @IBOutlet weak var lblDesc: UINCLabelNote!
    @IBOutlet weak var switcher: UINCSwitchDefault!
    
    struct source {
        static var nib: UINib = UINib(nibName: String(describing: SettingsSwitchCell.self), bundle: Bundle(for: SettingsSwitchCell.self))
        static var identifier: String = String(describing: SettingsSwitchCell.self)
    }
    
    weak var delegate: SettingsSwitchCellDelegate?
    
    var item: SettingItem? {
        didSet {
            updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        setupViews()
    }
    
    private func setupViews() {
        lblTitle.changeFontSize(size: 14)
        lblDesc.changeFontSize(size: 12)
        lblDesc.numberOfLines = 0
        switcher.onTintColor = UINCColor.brandColor()
        switcher.addTarget(self, action: #selector(didChangeSwitchState(_:)), for: .valueChanged)
    }
    
    private func updateUI() {
        lblTitle.text = item?.title
        lblDesc.text = item?.description
        lblDesc.isHidden = item?.description == nil ? true : false
        switcher.setOn(item?.usersValue ?? item?.defaultValue ?? false, animated: false)
    }
    
    func enableSwitcher() {
        switcher.isEnabled = true
    }
    
    @objc private func didChangeSwitchState(_ sender: UISwitch) {
        switcher.isEnabled = false
        delegate?.didChangeSwitchState(cell: self, isOn: sender.isOn)
    }
}
