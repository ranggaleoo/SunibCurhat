//
//  Aliasses.swift
//  SunibCurhat
//
//  Created by Developer on 05/04/21.
//  Copyright © 2021 Rangga Leo. All rights reserved.
//

import Foundation

typealias VoidClosure = (() -> Void)

enum FirebaseX {
    case ex
    
    enum FirestoreCollection {        
        case Chats(_ documentID: String?)
        case thread(_ documentID: String?)
        
        static func getPath(collections: [FirestoreCollection]) -> String {
            var paths: [String] = []
            
            for collection in collections {
                switch collection {
                
                case .Chats(let documentID):
                    let collection = collection.toString()
                    paths.append(collection)
                    if let documentID = documentID {
                        paths.append(documentID)
                    }
                    
                case .thread(let documentID):
                    let collection = collection.toString()
                    paths.append(collection)
                    if let documentID = documentID {
                        paths.append(documentID)
                    }
                }
            }
            let path = paths.joined(separator: "/")
            return path
        }
        
        private func toString() -> String {
            let array = String(describing: self).split(separator: "(")
            if let item = array.first {
                return String(describing: item)
            }
            return ""
        }
    }
}

typealias FBXFireCollection = FirebaseX.FirestoreCollection
