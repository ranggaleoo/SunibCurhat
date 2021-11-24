// 
//  ChatInteractor.swift
//  SunibCurhat
//
//  Created by Developer on 20/03/21.
//  Copyright © 2021 Rangga Leo. All rights reserved.
//

import Firebase
import Kingfisher

extension Firestore {
    func collection(_ paths: [FBXFireCollection]) -> CollectionReference {
        collection(FBXFireCollection.getPath(collections: paths))
    }
}

class ChatInteractor: ChatPresenterToInteractor {
    weak var presenter: ChatInteractorToPresenter?
    
    private let db = Firestore.firestore()
    private var reference: CollectionReference?
    private let storage = Storage.storage().reference()
    private var messageListener: ListenerRegistration?
    
    func listenMessage(chatID: String) {
        reference = db.collection([.Chats(chatID), .thread(nil)])
        messageListener = reference?.addSnapshotListener { querySnapshot, error in
            if let error = error {
                debugLog(error.localizedDescription)
            }
            guard let snapshot = querySnapshot else {
                return
            }
            
            snapshot.query.limit(to: 50).getDocuments(completion: { (querySnap, error) in
                if let error = error {
                    debugLog(error.localizedDescription)
                }
                guard let snap = querySnap else {
                    return
                }
                
                snap.documentChanges.forEach { [weak self] change in
                    guard var message = Message(document: change.document) else { return }
                    switch change.type {
                    case .modified, .removed: break
                    case .added:
                        if let url = message.url_image {
                            self?.downloadImage(at: url, completion: { (image) in
                                if let image = image {
                                    message.image = image
                                }
                            })
                        }
                        self?.presenter?.didListenMessage(message: message)
                    }
                }
            })
        }
    }
    
    func saveMessage(message: Message) {
        reference?.addDocument(data: message.representation) { [weak self] error in
            if let e = error {
                self?.presenter?.failSaveMessage(title: "Error", message: e.localizedDescription)
                return
            }
            self?.presenter?.didSaveMessage(message: message)
        }
    }
    
    func sendNotif(token: String, title: String, body: String) {
        MainService.shared.sendNotif(title: title, text: body, fcmToken: token, completion: { (result) in
            switch result {
            case .failure(let e):
                debugLog(e.localizedDescription)
            case .success(let s):
                debugLog(s)
            }
        })
    }
    
    func uploadImage(message: Message, imageData: Data, chatID: String, isSendingImage: Bool) {
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let imageName = [UUID().uuidString, String(Date().timeIntervalSince1970)].joined()
        let storageRef = storage.child(chatID).child(imageName)
        guard isSendingImage else { return }
        
        storageRef.putData(imageData, metadata: metadata) { meta, error in
            if let meta = meta {
                debugLog(meta)
            }
            
            if let error = error {
                debugLog(error.localizedDescription)
            }
            
            storageRef.downloadURL(completion: { [weak self] (url, error) in
                if let url = url {
                    var message = message
                    message.url_image = url
                    self?.presenter?.didUploadImage(message: message)
                }
                
                if let error = error {
                    debugLog(error.localizedDescription)
                }
            })
        }
    }
    
    private func downloadImage(at url: URL, completion: @escaping (UIImage?) -> Void) {
        let ref = Storage.storage().reference(forURL: url.absoluteString)
        let megaByte = Int64(1 * 1024 * 1024)
        
        ref.getData(maxSize: megaByte) { data, error in
            guard let imageData = data else {
                completion(nil)
                return
            }
            completion(UIImage(data: imageData))
        }
    }
    
    deinit {
        messageListener?.remove()
    }
}
