//
//  Chat+InputBar.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 02/09/19.
//  Copyright © 2019 Rangga Leo. All rights reserved.
//

import Foundation
import InputBarAccessoryView

extension ChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let message = Message(text_message: text)
        
        save(message)
        inputBar.inputTextView.text = ""
    }
}
