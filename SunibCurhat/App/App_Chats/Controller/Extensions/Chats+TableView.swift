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
}
