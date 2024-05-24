//
//  SocketEvent.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 12/05/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import Foundation

enum SocketEventRequest: String {
    case req_create_conversation
    case req_conversations
    case req_chats
    case req_send_chat
    case req_typing
    case req_mark_chat_read
    case req_update_block
}

enum SocketEventResponse: String {
    case res_user_online
    case res_user_offline
    case res_conversations
    case res_chats
    case res_send_chat
    case res_typing
    case res_mark_chat_read
    case res_update_block
}
