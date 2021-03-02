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
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension SettingsView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.numberOfRowsInSection ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
