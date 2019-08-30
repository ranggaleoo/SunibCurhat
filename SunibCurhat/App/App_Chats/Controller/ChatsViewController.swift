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
    
    private let db = Firestore.firestore()
    private var chatsReference: CollectionReference {
        return db.collection("Chats")
    }
    var chats: [Chat] = []
    private var chatListener: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("---- ViewDidLoad Chats")
        print(RepoMemory.user_firebase)
        delegates()
        
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
    
    private func delegates() {
        tableViewChats.delegate = self
        tableViewChats.dataSource = self
    }
    
    func createChatRoom(chat_id: String, name: String) {
        let chat = Chat(name: name, chat_id: chat_id)
        chatsReference.addDocument(data: chat.representation) { error in
            if let e = error {
                print("Error saving chat room: \(e.localizedDescription)")
                
            } else {
                guard let user = RepoMemory.user_firebase else {return}
                let vc = ChatViewController(user: user, chat: chat)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    deinit {
        chatListener?.remove()
    }
}
