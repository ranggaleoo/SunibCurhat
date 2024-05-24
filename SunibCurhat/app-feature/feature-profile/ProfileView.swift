//
//  ProfileView.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 05/03/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import UIKit
import Foundation

class ProfileView: UIViewController, ProfilePresenterToView {
    var presenter: ProfileViewToPresenter?
    
    @IBOutlet private weak var tableProfile: UITableView!
    
    init() {
        super.init(nibName: String(describing: ProfileView.self), bundle: Bundle(for: ProfileView.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.didLoad()
    }
    
    func setupViews() {
        title = "Profile"
        view.backgroundColor = UINCColor.bg_primary
        tableProfile.delegate = self
        tableProfile.dataSource = self
        tableProfile.register(ProfileAvatarCell.source.nib, forCellReuseIdentifier: ProfileAvatarCell.source.identifier)
    }
    
    func showConfirmation(title: String, message: String) {
        showAlert(title: title, message: message, OKcompletion: { [weak self] act in
            self?.presenter?.didConfirm()
        }, CancelCompletion: nil)
    }
    
    func showMessage(title: String, message: String) {
        showAlert(title: title, message: message, OKcompletion: nil, CancelCompletion: nil)
    }
    
    func startLoader() {
        showLoaderIndicator()
    }
    
    func stopLoader() {
        dismissLoaderIndicator()
    }
    
    @objc private func toggleSwitchHandler(_ sender: UISwitch) {
        if let section = sender.restorationIdentifier, let sectionInt = Int(section) {
            let indexPath = IndexPath(row: sender.tag, section: sectionInt)
            presenter?.didSwitch(isOn: sender.isOn, indexPath: indexPath)
        }
    }
}

extension ProfileView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter?.numberOfSections() ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfRowsInSection(section: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = presenter?.cellForRowAt(indexPath: indexPath)
        switch section?.type {
        case .avatar:
            if let avatarCell = tableView.dequeueReusableCell(withIdentifier: ProfileAvatarCell.source.identifier) as? ProfileAvatarCell {
                return avatarCell
            }
        case .list:
            let listCell = UITableViewCell(style: .default, reuseIdentifier: nil)
            if let item = section?.items?.item(at: indexPath.row) {
                if #available(iOS 14.0, *) {
                    var content = UIListContentConfiguration.cell()
                    content.text = item.title
                    content.secondaryText = item.type == .action_toggle ? item.description : nil
                    listCell.contentConfiguration = content
                } else {
                    listCell.textLabel?.text = item.title
                    listCell.detailTextLabel?.text = item.type == .action_toggle ? item.description : nil
                }
                
                if item.type == .action_toggle, let itemID = item.id {
                    let toggle = UISwitch()
                    toggle.onTintColor = UINCColor.primary
                    toggle.addTarget(self, action: #selector(toggleSwitchHandler(_:)), for: .valueChanged)
                    toggle.accessibilityIdentifier = itemID
                    toggle.tag = indexPath.row
                    toggle.restorationIdentifier = "\(indexPath.section)"
                    switch item.content {
                    case .bool(value: let boolValue):
                        toggle.setOn(boolValue, animated: true)
                        let dataToggle = UDHelpers.shared.getBool(keyString: itemID)
                        toggle.setOn(dataToggle, animated: true)
                        
                    default:
                        break
                    }
                    listCell.accessoryView = toggle
                }
                
                return listCell
            }            
            
        default:
            return UITableViewCell()
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let moblieSection = presenter?.cellForRowAt(indexPath: IndexPath(row: 0, section: section))
        if moblieSection?.type == .avatar {
            return nil
        }
        return presenter?.titleForHeaderInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectRowAt(indexPath: indexPath)
    }
}
