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
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_text_content: UILabel!
    @IBOutlet weak var lbl_time: UILabel!
    
    var timeline: TimelineResponse? {
        didSet {
            self.updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func updateUI() {
        DispatchQueue.main.async {
            self.lbl_name.text = self.timeline?.name
            self.lbl_text_content.text = self.timeline?.text_content
            self.lbl_time.text = self.timeline?.timed
        }
    }
    
    private func delegates() {
        tableViewComment.delegate = self
        tableViewComment.dataSource = self
    }
    
    @objc func getComments() {
        
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
