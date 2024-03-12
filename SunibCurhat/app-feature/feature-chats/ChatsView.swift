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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.didLoad()
    }
    
    func setupViews() {
        view.backgroundColor = UINCColor.bg_primary
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
    
    func createConversationFromTimeline(conversation: Conversation) {
        presenter?.createConversation(conversation: conversation)
    }
    
    func insertRow(at: [IndexPath]) {
        tableChats.insertRows(at: at, with: .automatic)
    }
    
    func showAlertMessage(title: String, message: String) {
        showAlert(title: title, message: message, OKcompletion: nil, CancelCompletion: nil)
    }
}

extension ChatsView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfRowsInSection() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let conversation = presenter?.cellForRowAt(indexPath: indexPath)
        if let cell = tableView.dequeueReusableCell(withIdentifier: ChatCell.source.identifier) as? ChatCell {
            cell.set(conversation: conversation)
            return cell
        }
        return UITableViewCell()
    }
}
