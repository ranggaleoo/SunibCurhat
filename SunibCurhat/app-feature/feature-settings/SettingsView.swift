//
//  SettingsView.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 02/03/21.
//  Copyright © 2021 Rangga Leo. All rights reserved.
//

import UIKit
import Foundation

class SettingsView: UIViewController, SettingsPresenterToView {
    var presenter: SettingsViewToPresenter?
    
    @IBOutlet weak var tableView: UITableView!
    
    init() {
        super.init(nibName: String(describing: SettingsView.self), bundle: Bundle(for: SettingsView.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.didLoad()
    }
    
    func setupViews() {
        title = "Settings"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(SettingsSwitchCell.source.nib, forCellReuseIdentifier: SettingsSwitchCell.source.identifier)
    }
    
    func enableSwitcher(indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? SettingsSwitchCell {
            cell.enableSwitcher()
        }
    }
    
    func showAlertConfirm(title: String, message: String, okCompletion: (() -> Void)?, cancelCompletion: (() -> Void)?) {
        super.showAlert(title: title, message: message) { (_) in
            okCompletion?()
        } CancelCompletion: { (_) in
            cancelCompletion?()
        }
    }
    
    func reloadTableView() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

extension SettingsView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.numberOfRowsInSection() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: SettingsSwitchCell.source.identifier) as? SettingsSwitchCell {
            cell.delegate = self
            cell.item = presenter?.cellForRowAt(indexPath: indexPath)
            return cell
        }
        return UITableViewCell()
    }
}

extension SettingsView: SettingsSwitchCellDelegate {
    func didChangeSwitchState(cell: SettingsSwitchCell, isOn: Bool) {
        if let indexPath = tableView.indexPath(for: cell) {
            presenter?.saveSettingSwitch(indexPath: indexPath, isOn: isOn)
        }
    }
}
