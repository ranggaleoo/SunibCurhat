//
//  ChatsViewController.swift
//  SunibCurhat
//
//  Created by Koinworks on 8/27/19.
//  Copyright © 2019 Rangga Leo. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatsViewController: UIViewController {
    
    @IBOutlet weak var tableViewChats: UITableView!
    
    var timeline: TimelineItems! {
        didSet {
            var chat_id = RepoMemory.device_id + "+" + timeline.device_id
            var name = timeline.name
            self.createChatRoom(chat_id: chat_id, name: name)
        }
    }
    
    private let db = Firestore.firestore()
    private var chatsReference: CollectionReference {
        return db.collection("Chats")
    }
    var chats: [Chat] = []
    private var chatListener: ListenerRegistration?
    private var currentUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatListener = chatsReference.addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
                return
            }
            
            snapshot.documentChanges.forEach { change in
                self.handleDocumentChange(change)
            }
        }
    }
    
    private func createChatRoom(chat_id: String, name: String) {
        let chat = Chat(name: name, chat_id: chat_id)
        chatsReference.addDocument(data: chat.representation) { error in
            if let e = error {
                print("Error saving chat room: \(e.localizedDescription)")
            }
        }
    }
    
    deinit {
        chatListener?.remove()
    }
}
