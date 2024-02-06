//
//  ChatsViewController.swift
//  SunibCurhat
//
//  Created by Koinworks on 8/27/19.
//  Copyright © 2019 Rangga Leo. All rights reserved.
//

import UIKit

class ChatsViewController: UIViewController {
    
    @IBOutlet weak var tableViewChats: UITableView!
    private lazy var refreshControl: UIRefreshControl = {
        let r = UIRefreshControl()
        r.tintColor = UIColor.custom.gray
        r.attributedTitle = NSAttributedString(string: "Fetching chats..", attributes: [NSAttributedString.Key.font: UIFont.custom.regular.size(of: 12)])
        return r
    }()
    
    var chats: [Chat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        debugLog("---- ViewDidLoad Chats")
        delegates()
        setupListener()
        setupViews()
    }
    
    @objc private func setupListener() {
        
    }
    
    private func delegates() {
        tableViewChats.delegate = self
        tableViewChats.dataSource = self
    }
    
    private func setupViews() {
        self.navigationDefault()
        title = "Chats"
        tableViewChats.tableFooterView = UIView()
        if #available(iOS 10.0, *) {
            tableViewChats.refreshControl = refreshControl
        } else {
            tableViewChats.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(setupListener), for: .valueChanged)
    }
    
    func createChatRoom(chat_id: String, name: String, users: [String]) {
        
    }
    
    deinit {
    }
}
