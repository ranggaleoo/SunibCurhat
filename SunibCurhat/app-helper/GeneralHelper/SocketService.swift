//
//  SocketService.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 25/02/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import Foundation
import SocketIO

protocol SocketDelegate: AnyObject {
    func didGetUsers(users: [Any]?)
}

enum SocketEvent: String {
    case req_join
}

extension SocketIOClient {
//    func on<Event: SocketEvent>(_ event: Event.Type, handler: @escaping (Event.DataType, SocketAckEmitter) -> Void) {
//        on(Event.eventName) { data, ack in
//            do {
//                let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
//                let decodedData = try JSONDecoder().decode(Event.DataType.self, from: jsonData)
//                handler(decodedData, ack)
//            } catch let err {
//                debugLog("Error decoding data for event \(Event.eventName):", err.localizedDescription)
//            }
//        }
//    }
    
    func emit(_ event: SocketEvent, data: Codable, _ completion: (() -> Void)? = nil) {
        do {
            let jsonData = try JSONEncoder().encode(data)
            self.emit(event.rawValue, jsonData) {
                completion?()
            }
        } catch let err {
            debugLog("Error encoding data for event \(event.rawValue):", err.localizedDescription)
        }
    }
}

class SocketService {
    static let shared = SocketService()
    private var socketManager: SocketManager?
    private var socket: SocketIOClient?
    private var socketURL: String = "https://vast-lamb-smooth.ngrok-free.app"
    
    weak var delegate: SocketDelegate?
    
    private init() {}
    
    func establishConnection() {
        guard socketManager == nil,
              let url = URL(string: socketURL)
        else { return }
        
        let user = UDHelpers.shared.getObject(type: User.self, forKey: .user)
        let session_id = UDHelpers.shared.getString(key: .chat_session_id)
        debugLog(user)
        debugLog(session_id)
        
        if let _user = user,
           let _session_id = session_id,
           !(socketManager?.engine?.connected ?? false) {
            debugLog("auth socket using: ", _user.user_id, _session_id)
            socketManager = SocketManager(
                socketURL: url,
                config: [
                    .log(true),
                    .compress,
                    .connectParams([
                        "user_id": _user.user_id,
                        "session_id": _session_id
                    ])
                ])
            socket = socketManager?.defaultSocket
            socket?.connect()
            self.addEventHandlers()
            
        } else if let _user = user,
                  !(socketManager?.engine?.connected ?? false) {
            debugLog("auth socket using: ", _user.user_id)
            socketManager = SocketManager(
                socketURL: url,
                config: [
                    .log(true),
                    .compress,
                    .connectParams([
                        "user_id": _user.user_id,
                    ])
                ]
            )
            socket = socketManager?.defaultSocket
            socket?.connect()
            
            socket?.on("session", callback: { [weak self] (data, ack) in
                let session_id = data[0] as? String
                if let _session_id = session_id {
                    self?.socketManager = SocketManager(
                        socketURL: url,
                        config: [
                            .log(true),
                            .compress,
                            .connectParams([
                                "user_id": _user.user_id,
                                "session_id": _session_id
                            ])
                        ])
                    self?.socket = self?.socketManager?.defaultSocket
                    UDHelpers.shared.set(value: _session_id, key: .chat_session_id)
                    self?.addEventHandlers()
                }
            })
            
        } else {
            debugLog("disconnect socket")
            socket?.disconnect()
        }
    }
    private func addEventHandlers() {
        socket?.onAny({ eHandler in
            debugLog(eHandler.description)
            debugLog(eHandler.event)
            debugLog(eHandler.items)
        })
        
        socket?.on("get-users", callback: { [weak self] (users: [Any], ack) in
            self?.delegate?.didGetUsers(users: users)
        })
    }
    
    func reqJoin(data: ChatRequestJoin) {
        socket?.emit(.req_join, data: data)
    }
    
    func set(URL: String) {
        socketURL = URL
    }
    
    func connect() {
        socket?.connect()
    }
    
    func disconnect() {
        socket?.disconnect()
    }
}

struct ChatSession: Codable {
    let session_id: String
    let user_id: String
    let connected: Bool
}

struct ChatConversation: Codable {
    let from: String
    let last_message: String
    let last_message_time: String
    let total_unread_message: String
}

struct ChatRequestJoin: Codable {
    let from: String
    let to: String
}

