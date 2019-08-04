//
//  CommentCurhatViewController.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 04/08/19.
//  Copyright © 2019 Rangga Leo. All rights reserved.
//

import Foundation
import UIKit

class CommentCurhatViewController: UIViewController {
    @IBOutlet weak var tableViewComment: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func delegates() {
        tableViewComment.delegate = self
        tableViewComment.dataSource = self
    }
}

extension CommentCurhatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}
