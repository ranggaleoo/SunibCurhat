//
//  ChatView.swift
//  SunibCurhat
//
//  Created by Developer on 20/03/21.
//  Copyright © 2021 Rangga Leo. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class ChatView: MessagesViewController, ChatPresenterToView {
    var presenter: ChatViewToPresenter?
    
    init() {
        super.init(nibName: String(describing: ChatView.self), bundle: Bundle(for: ChatView.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.didLoad()
    }
    
    func setupViews(title: String) {
        self.title = title
        navigationDefault()
        
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
        cameraItem.image        = UIImage(identifierName: .btn_camera)
        cameraItem.addTarget(
            self,
            action: #selector(didTapBtnCamera), // 2
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
    
    func scrollToBottom() {
        messagesCollectionView.scrollToBottom()
    }
    
    func reloadCollectionView(isLastMessage: Bool) {
        let shouldScrollToBottom = messagesCollectionView.isAtBottom && isLastMessage
        messagesCollectionView.reloadData()
        
        if shouldScrollToBottom {
            DispatchQueue.main.async { [weak self] in
                self?.messagesCollectionView.scrollToBottom(animated: true)
            }
        }
    }
    
    func showAlertConfirm(title: String, message: String, okCompletion: VoidClosure?, cancelCompletion: VoidClosure?) {
        showAlert(title: title, message: message) { (_) in
            okCompletion?()
        } CancelCompletion: { (_) in
            cancelCompletion?()
        }
    }
    
    @objc private func didTapBtnCamera() {
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
}

extension ChatView: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        presenter?.didPressSendButtonWith(text: text)
        inputBar.inputTextView.text = ""
    }
}

extension ChatView: MessagesLayoutDelegate { }

extension ChatView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage { // 2
            guard let scaledImage = image.scaledToSafeUploadSize, let data = scaledImage.jpegData(compressionQuality: 0.5) else { return }
            let message = Message(image: image)
            presenter?.didGetPhoto(message: message, imageData: data)
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension ChatView: MessagesDataSource {
    func currentSender() -> SenderType {
        guard let sender = presenter?.getCurrentSender() else { return Sender(senderId: "", displayName: "") }
        return Sender(senderId: sender.id, displayName: sender.name)
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        guard let message = presenter?.messageForItem(at: indexPath) else { return Message(text_message: "") }
        return message
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        presenter?.numberOfSections() ?? 0
    }
}

extension ChatView: MessagesDisplayDelegate {
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(corner, .curved)
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        switch message.kind {
        case .emoji:
            return .clear
        default:
            guard let dataSource = messagesCollectionView.messagesDataSource else { return .white }
            return dataSource.isFromCurrentSender(message: message) ? UIColor.custom.blue : UIColor.custom.gray
        }
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        avatarView.isHidden = true
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        guard let dataSource = messagesCollectionView.messagesDataSource else {
            fatalError("data source nil")
        }
        return dataSource.isFromCurrentSender(message: message) ? .white : .white
    }
}
