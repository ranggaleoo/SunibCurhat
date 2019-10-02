//
//  ChatViewController.swift
//  SunibCurhat
//
//  Created by Koinworks on 8/29/19.
//  Copyright © 2019 Rangga Leo. All rights reserved.
//

import UIKit
import Firebase
import MessageKit
import FirebaseFirestore
import InputBarAccessoryView

final class ChatViewController: MessagesViewController {
    
    private let db = Firestore.firestore()
    private var reference: CollectionReference?
    private let storage = Storage.storage().reference()
    
    var messages: [Message] = []
    private var messageListener: ListenerRegistration?
    private let chat: Chat
    
    var isSendingImage: Bool = false
    var token_fcm_target: String = ""
    deinit {
        messageListener?.remove()
    }
    
    init(chat: Chat) {
        self.chat   = chat
        super.init(nibName: nil, bundle: nil)
        self.title  = chat.name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupListener()
        delegates()
    }
    
    // MARK: - Setups
    private func setupListener() {
        guard let id = chat.id else {
            navigationController?.popViewController(animated: true)
            return
        }
        reference = db.collection(["Chats", id, "thread"].joined(separator: "/"))
        
        messageListener = reference?.addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
                return
            }
            
            snapshot.query.limit(to: 50).getDocuments(completion: { (querySnap, error) in
                guard let s = querySnap else {
                    print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
                    return
                }
                
                s.documentChanges.forEach { change in
                    self.handleDocumentChange(change)
                }
            })
        }
    }
    
    private func delegates() {
        self.setupMoreBarButtonItem { (act) in
            let sb = UIStoryboard(name: "Report", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "view_report") as! ReportViewController
            vc.chat = self.chat
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode        = .never
        } else {
            // Fallback on earlier versions
        }
        maintainPositionOnKeyboardFrameChanged      = true
        messageInputBar.inputTextView.tintColor     = UIColor.custom.blue
        messageInputBar.sendButton.setTitleColor(UIColor.custom.blue, for: .normal)
        
        messageInputBar.delegate                        = self
        messagesCollectionView.messagesDataSource       = self
        messagesCollectionView.messagesLayoutDelegate   = self
        messagesCollectionView.messagesDisplayDelegate  = self
        
        let cameraItem          = InputBarButtonItem(type: .system) // 1
        cameraItem.tintColor    = UIColor.custom.gray
        cameraItem.image        = UIImage(named: "btn_camera")
        cameraItem.addTarget(
            self,
            action: #selector(cameraButtonPressed), // 2
            for: .primaryActionTriggered
        )
        cameraItem.setSize(CGSize(width: 60, height: 30), animated: false)
        
        messageInputBar.leftStackView.alignment = .center
        messageInputBar.setLeftStackViewWidthConstant(to: 50, animated: false)
        messageInputBar.setStackViewItems([cameraItem], forStack: .left, animated: false) // 3
        
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
            layout.textMessageSizeCalculator.incomingAvatarSize = .zero
        }
        
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            layout.setMessageIncomingAvatarSize(.zero)
            layout.setMessageOutgoingAvatarSize(.zero)
        }
    }
    
    // MARK: - Actions
    
    @objc private func cameraButtonPressed() {
        let picker = UIImagePickerController()
        picker.delegate = self
        
        let alert = UIAlertController(title: "Take a photo", message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (act) in
                picker.sourceType = .camera
                self.present(picker, animated: true, completion: nil)
            }))
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (act) in
                picker.sourceType = .photoLibrary
                self.present(picker, animated: true, completion: nil)
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    
    func save(_ message: Message) {
        reference?.addDocument(data: message.representation) { error in
            if let e = error {
                print("Error sending message: \(e.localizedDescription)")
                return
            }
            
            self.messagesCollectionView.scrollToBottom()
            MainService.shared.sendNotif(title: self.chat.name, text: message.text_message, fcmToken: self.token_fcm_target, completion: { (result) in
                switch result {
                case .failure(let e):
                    print(e.localizedDescription)
                case .success(let s):
                    print(s)
                }
            })
        }
    }
    
    private func insertNewMessage(_ message: Message) {
        guard !messages.contains(message) else {
            return
        }
        
        messages.append(message)
        messages.sort()
        
        let isLatestMessage = messages.firstIndex(of: message) == (messages.count - 1)
        let shouldScrollToBottom = messagesCollectionView.isAtBottom && isLatestMessage
        
        messagesCollectionView.reloadData()
        
        if shouldScrollToBottom {
            DispatchQueue.main.async {
                self.messagesCollectionView.scrollToBottom(animated: true)
            }
        }
    }
    
    private func handleDocumentChange(_ change: DocumentChange) {
        guard var message = Message(document: change.document) else {
            return
        }
        
        switch change.type {
        case .added:
            if let url = message.url_image {
                downloadImage(at: url) { [weak self] image in
                    guard let `self` = self else {
                        return
                    }
                    guard let image = image else {
                        return
                    }
                    
                    message.image = image
                    self.insertNewMessage(message)
                }
            } else {
                insertNewMessage(message)
            }
            
        default:
            break
        }
        
        let device_id = message.sender.senderId
        if device_id != RepoMemory.device_id {
            token_fcm_target = message.token_fcm ?? "token"
        }
    }
    
    private func uploadImage(_ image: UIImage, to chat: Chat, completion: @escaping (URL?) -> Void) {
        guard let id = chat.id else {
            completion(nil)
            return
        }
        
        guard let scaledImage = image.scaledToSafeUploadSize, let data = scaledImage.jpegData(compressionQuality: 0.5) else {
            completion(nil)
            return
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let imageName = [UUID().uuidString, String(Date().timeIntervalSince1970)].joined()
        let storageRef = storage.child(id).child(imageName)
        
        guard self.isSendingImage else { return }
            
        storageRef.putData(data, metadata: metadata) { meta, error in
            if let m = meta {
                print(m)
            }
            
            if let e = error {
                print(e.localizedDescription)
            }
            
            storageRef.downloadURL(completion: { (url, e) in
                if let u = url {
                    completion(u)
                    self.isSendingImage = false
                }
                
                if let error = e {
                    print(error.localizedDescription)
                }
            })
        }
    }
    
    func sendPhoto(_ image: UIImage) {
        self.isSendingImage = true
        self.showLoaderIndicator()
        uploadImage(image, to: chat) { [weak self] url in
            guard let `self` = self else {
                return
            }
            self.dismissLoaderIndicator()
            
            guard let url_image = url else {
                return
            }
            
            var message = Message(image: image)
            message.url_image = url_image
            
            self.save(message)
            self.messagesCollectionView.scrollToBottom()
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
    
}
