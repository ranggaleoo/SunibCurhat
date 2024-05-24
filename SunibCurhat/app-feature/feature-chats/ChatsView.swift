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
    private lazy var refreshControlSimple: UINCRefreshControlSimple = UINCRefreshControlSimple()
    
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
        navigationDefault()
        title = "Chats"
        view.backgroundColor = UINCColor.bg_primary
        tableChats.delegate = self
        tableChats.dataSource = self
        tableChats.tableFooterView = UIView()
        tableChats.register(ChatCell.source.nib, forCellReuseIdentifier: ChatCell.source.identifier)
        
        refreshControlSimple.addTarget(self, action: #selector(didRefresh), for: .valueChanged)
        tableChats.backgroundView = refreshControlSimple
    }
    
    func createConversationFromTimeline(conversation: Conversation) {
        presenter?.createConversation(conversation: conversation)
    }
    
    func insertRow(at: [IndexPath]) {
        tableChats.insertRows(at: at, with: .automatic)
    }
    
    func reloadRow(at: [IndexPath]) {
        tableChats.reloadRows(at: at, with: .automatic)
    }
    
    func reloadData() {
        tableChats.reloadData()
    }
    
    func dismissRefreshControl() {
        refreshControlSimple.endRefreshing()
    }
    
    func showAlertMessage(title: String, message: String) {
        showAlert(title: title, message: message, OKcompletion: nil, CancelCompletion: nil)
    }
    
    func didPopFromChatView(conversation: Conversation?) {
        presenter?.syncConversation(conversation: conversation)
    }
    
    @objc private func didRefresh() {
        presenter?.didRefresh()
    }
    
    private func makeContextualDeleteAction(forRowAtIndexPath: IndexPath) -> UIContextualAction {
        let action  = UIContextualAction(style: .destructive, title: nil) { [weak self] (action, view, completion) in
            
        }
        action.image = UIImage(symbol: .Trash)
        action.backgroundColor = UINCColor.error
        return action
    }
}

extension ChatsView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRow = presenter?.numberOfRowsInSection() ?? 0
        if numberOfRow > 0 {
            tableView.backgroundView = refreshControlSimple
            return numberOfRow
        } else {
            tableView.setViewForEmptyData(image: UIImage(symbol: .BubbleLeft), message: "No Chat Today, Let's Chat!")
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ChatCell.source.identifier) as? ChatCell,
           let conversation = presenter?.cellForRowAt(indexPath: indexPath) {
            cell.set(conversation: conversation)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectRowAt(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = makeContextualDeleteAction(forRowAtIndexPath: indexPath)
        let configuration = UISwipeActionsConfiguration(actions: [])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height {
            presenter?.didScroll()
        }
    }
}
