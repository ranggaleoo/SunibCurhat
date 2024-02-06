//
//  ChatViewController.swift
//  SunibCurhat
//
//  Created by Koinworks on 8/29/19.
//  Copyright © 2019 Rangga Leo. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView

final class ChatViewController: MessagesViewController {
    
    var messages: [Message] = []
    private let chat: Chat
    
    var isSendingImage: Bool = false
    var token_fcm_target: String?
    deinit {
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
        
    }
    
    private func delegates() {
        self.navigationDefault()
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
                self.messagesCollectionView.scrollToLastItem(animated: true)
            }
        }
    }
    
    private func uploadImage(_ image: UIImage, to chat: Chat, completion: @escaping (URL?) -> Void) {
        
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
            self.messagesCollectionView.scrollToLastItem(animated: true)
        }
    }
    
    private func downloadImage(at url: URL, completion: @escaping (UIImage?) -> Void) {
        
    }
    
}
