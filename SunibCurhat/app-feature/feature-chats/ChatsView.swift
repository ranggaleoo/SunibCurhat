//
//  ChatsView.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 24/02/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import UIKit
import Foundation

class ChatsView: UIViewController, ChatsPresenterToView {
    var presenter: ChatsViewToPresenter?
    
    @IBOutlet private weak var tableChats: UITableView!
    private var refreshControl: UINCRefreshControl = UINCRefreshControl()
    
    init() {
        super.init(nibName: String(describing: ChatsView.self), bundle: Bundle(for: ChatsView.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.didLoad()
    }
    
    func setupViews() {
        tableChats.delegate = self
        tableChats.dataSource = self
        tableChats.register(ChatCell.source.nib, forCellReuseIdentifier: ChatCell.source.identifier)
        
        refreshControl.setMaxHeightOfRefreshControl = 200
        refreshControl.setRefreshCircleSize = .medium
        refreshControl.setFillColor = UINCColor.primary
        tableChats.backgroundView = refreshControl
        
        refreshControl.setOnRefreshing = { [weak self] in
            // get list chats
        }
        
        navigationDefault()
        title = "Chats"
    }
}

extension ChatsView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfRowsInSection() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ChatCell.source.identifier) as? ChatCell {
            return cell
        }
        return UITableViewCell()
    }
}
