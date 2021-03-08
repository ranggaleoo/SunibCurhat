//
//  CodableStorage.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 02/03/21.
//  Copyright © 2021 Rangga Leo. All rights reserved.
//

import Foundation

class CodableStorage {
    private let storage: DiskStorage
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    init(
        storage: DiskStorage,
        decoder: JSONDecoder = .init(),
        encoder: JSONEncoder = .init()
    ) {
        self.storage = storage
        self.decoder = decoder
        self.encoder = encoder
    }

    func fetch<T: Decodable>(for key: String) throws -> T {
        let data = try storage.fetchValue(for: key)
        return try decoder.decode(T.self, from: data)
    }
    
    func fetch<T: Decodable>(for key: String, object: T.Type, handler: @escaping Handler<T>) {
        storage.fetchValue(for: key) { (result) in
            switch result {
            case .failure(let err):
                handler(.failure(err))
            case .success(let data):
                if let response = try? self.decoder.decode(T.self, from: data) {
                    handler(.success(response))
                }
            }
        }
    }

    func save<T: Encodable>(_ value: T, for key: String) throws {
        let data = try encoder.encode(value)
        try storage.save(value: data, for: key)
    }
}

