//
//  Chats+TableView.swift
//  SunibCurhat
//
//  Created by Koinworks on 8/29/19.
//  Copyright © 2019 Rangga Leo. All rights reserved.
//

import Foundation
import UIKit

extension ChatsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if chats.count == 0 {
            tableView.setViewForEmptyData(image: UIImage(named: "img_empty_table"), message: "No chat today, let's chat")
            return 0
        } else {
            tableView.backgroundView = nil
            return chats.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatsTableViewCell", for: indexPath) as! ChatsTableViewCell
        cell.chat = chats[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chat = chats[indexPath.row]
        let vc = ChatViewController(chat: chat)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let chat_id = chats[indexPath.row].id else {return}
            self.chatsReference.document(chat_id).delete { (e) in
                print(e?.localizedDescription ?? "no error when delete chat")
                if e == nil {
                    self.chats.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .left)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let blockButton = UITableViewRowAction(style: .normal, title: "Block") { (action, indexPath) in
            tableView.dataSource?.tableView?(self.tableViewChats, commit: .delete, forRowAt: indexPath)
        }
        
        blockButton.backgroundColor = UIColor.custom.red_absolute
        return [blockButton]
    }
}
