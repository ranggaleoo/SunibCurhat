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
    func didGetConversations(response: ResponseConversations)
    func failGetConversations(message: String)
    
    func didReceiveChat(chat: Chat)
    func failGetChats(message: String)
    
    func didUserTyping(chat: Chat)
    
    func didGetChats(response: ResponseChats)
    
    func didUpdateBlockUser(conversation: Conversation)
    func failUpdateBlock(message: String)
}

// default implementation
extension SocketDelegate {
    func didGetConversations(response: ResponseConversations) { }
    func failGetConversations(message: String) { }
    
    func didReceiveChat(chat: Chat) { }
    func failGetChats(message: String) { }
    
    func didUserTyping(chat: Chat) { }
    
    func didGetChats(response: ResponseChats) { }
    
    func didUpdateBlockUser(conversation: Conversation) { }
    func failUpdateBlock(message: String) { }
}

enum SocketIOError: Error {
    case encodingFailed
    case decodingFailed
}

extension SocketIOClient {
    func emit<T: Encodable>(_ event: String, withData data: T, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let jsonData = try JSONEncoder().encode(data)
            guard let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
                completion(.failure(SocketIOError.encodingFailed))
                return
            }
            self.emit(event, jsonDict)
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
    
    func on<T: Decodable>(_ event: String, completion: @escaping (Result<T, Error>) -> Void) {
        self.on(event) { data, _ in
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: data[0])
                let decodedData = try JSONDecoder().decode(T.self, from: jsonData)
                debugLog(decodedData)
                completion(.success(decodedData))
            } catch {
                debugLog(error)
                completion(.failure(error))
            }
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
        
        if let _user = user,
           !(socketManager?.engine?.connected ?? false) {
            let encoder = JSONEncoder()
            guard let jsonData = try? encoder.encode(_user) else {
                debugLog("failed encode object user")
                return
            }
            let userString = jsonData.base64EncodedString()
            
            socketManager = SocketManager(
                socketURL: url,
                config: [
                    .log(true),
                    .compress,
                    .connectParams([
                        "user_id": _user.user_id,
                        "user": userString
                    ]),
                    .log(false)
                ])
            socket = socketManager?.defaultSocket
            socket?.connect()
            self.addEventHandlers()
        } else {
            debugLog("disconnect socket")
            socket?.disconnect()
        }
    }
    private func addEventHandlers() {
        socket?.onAny({ eHandler in
            debugLog(eHandler.event)
        })
        
        self.on(.res_conversations) { [weak self] (result: Result<ResponseConversations, Error>) in
            switch result {
            case .success(let response):
                self?.delegate?.didGetConversations(response: response)
            case .failure(let error):
                self?.delegate?.failGetConversations(message: error.localizedDescription)
            }
        }
        
        self.on(.res_send_chat) { [weak self] (result: Result<Chat, Error>) in
            switch result {
            case .success(let chat):
                self?.delegate?.didReceiveChat(chat: chat)
            case .failure(let error):
                self?.delegate?.failGetChats(message: error.localizedDescription)
            }
        }
        
        self.on(.res_typing) { [weak self] (result: Result<Chat, Error>) in
            switch result {
            case .success(let chat):
                self?.delegate?.didUserTyping(chat: chat)
            case .failure(let err):
                debugLog(err.localizedDescription)
                break
            }
        }
        
        self.on(.res_chats) { [weak self] (result: Result<ResponseChats, Error>) in
            switch result {
            case .success(let res):
                self?.delegate?.didGetChats(response: res)
            case .failure(let err):
                debugLog(err.localizedDescription)
                break
            }
        }
        
        self.on(.res_update_block) { [weak self] (result: Result<Conversation, Error>) in
            switch result {
            case .success(let res):
                self?.delegate?.didUpdateBlockUser(conversation: res)
            case .failure(let err):
                self?.delegate?.failUpdateBlock(message: err.localizedDescription)
            }
            
        }
    }
    
    func set(URL: String) {
        socketURL = URL
    }
    
    func emit<T: Encodable>(_ event: SocketEventRequest, _ data: T, completion: @escaping (Result<Void, Error>) -> Void) {
        socket?.emit(event.rawValue, withData: data, completion: completion)
    }
    
    func on<T: Decodable>(_ event: SocketEventResponse, completion: @escaping (Result<T, Error>) -> Void) {
        socket?.on(event.rawValue, completion: completion)
    }
    
    func connect() {
        socket?.connect()
    }
    
    func disconnect() {
        socket?.disconnect()
    }
}

enum SocketEventRequest: String {
    case req_create_conversation
    case req_conversations
    case req_chats
    case req_send_chat
    case req_typing
    case req_update_block
}

enum SocketEventResponse: String {
    case res_conversations
    case res_chats
    case res_send_chat
    case res_typing
    case res_update_block
}
