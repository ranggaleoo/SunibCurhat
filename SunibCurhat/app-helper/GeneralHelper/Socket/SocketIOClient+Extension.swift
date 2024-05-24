//
//  SocketIOClient+Extension.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 12/05/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import Foundation
import SocketIO

extension SocketIOClient {
    func emit<T: Encodable>(_ event: String, withData data: T, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let jsonData = try JSONEncoder().encode(data)
            // Try to convert the JSON data to a dictionary or an array
            let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
            
            if let jsonDict = jsonObject as? [String: Any] {
                // If the JSON object is a dictionary
                self.emit(event, jsonDict)
                completion(.success(()))
            } else if let jsonArray = jsonObject as? [[String: Any]] {
                // If the JSON object is an array of dictionaries
                self.emit(event, jsonArray)
                completion(.success(()))
            } else {
                // If the JSON object is neither a dictionary nor an array of dictionaries
                completion(.failure(SocketIOError.encodingFailed))
            }
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
