//
//  ChatsViewController.swift
//  SunibCurhat
//
//  Created by Koinworks on 8/27/19.
//  Copyright © 2019 Rangga Leo. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatsViewController: UIViewController {
    
    @IBOutlet weak var tableViewChats: UITableView!
    private lazy var refreshControl: UIRefreshControl = {
        let r = UIRefreshControl()
        r.tintColor = UIColor.custom.gray
        r.attributedTitle = NSAttributedString(string: "Fetching chats..", attributes: [NSAttributedString.Key.font: UIFont.custom.regular.size(of: 12)])
        return r
    }()
    
    private let db = Firestore.firestore()
    var chatsReference: CollectionReference {
        return db.collection("Chats")
    }
    var chats: [Chat] = []
    private var chatListener: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("---- ViewDidLoad Chats")
        delegates()
        setupListener()
        setupViews()
    }
    
    @objc private func setupListener() {
        chatListener = chatsReference.addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
                return
            }
            
            snapshot.query.whereField("users", arrayContains: RepoMemory.device_id).getDocuments(completion: { (s, e) in
                guard let snapshot = s else {
                    print(e?.localizedDescription ?? "error snapshot")
                    return
                }
                
                snapshot.documentChanges.forEach({ (change) in
                    self.handleDocumentChange(change)
                    self.refreshControl.endRefreshing()
                })
            })
        }
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
        let chat = Chat(name: name, chat_id: chat_id, users: users)
        guard chatListener != nil else { return }
        
        if chats.contains(chat) {
            let vc = ChatViewController(chat: chat)
            self.navigationController?.pushViewController(vc, animated: true)
        
        } else {
            chatsReference.addDocument(data: chat.representation) { error in
                if let e = error {
                    print("Error saving chat room: \(e.localizedDescription)")
                    
                } else {
                    let vc = ChatViewController(chat: chat)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    deinit {
        chatListener?.remove()
    }
}
