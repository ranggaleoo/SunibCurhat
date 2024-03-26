//
//  ChatView.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 11/03/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import UIKit
import Foundation
import MessageKit
import InputBarAccessoryView
import Kingfisher
import PermissionsKit

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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messageInputBar.inputTextView.becomeFirstResponder()
        messagesCollectionView.scrollToLastItem()
    }
    
    func setupViews(name: String?) {
        /// setup navigation bar
        title = name
        navigationDefault()
        let moreButtonItem = UIBarButtonItem(image: UIImage(symbol: .EllipsisCircleFill), style: .plain, target: self, action: #selector(moreDidPressed))
        navigationItem.rightBarButtonItems = [moreButtonItem]
        
        /// delegate
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        navigationController?.delegate = self
        
        maintainPositionOnInputBarHeightChanged = true
        messageInputBar.inputTextView.tintColor = UINCColor.primary
        messageInputBar.sendButton.setTitleColor(UINCColor.primary, for: .normal)
        
        /// create camera button item
        let cameraItem = InputBarButtonItem(type: .system)
        cameraItem.tintColor = UINCColor.tertiary
        cameraItem.image = UIImage(symbol: .CameraFill)
        cameraItem.setSize(CGSize(width: 60, height: 30), animated: true)
        cameraItem.addTarget(self, action: #selector(cameraDidPressed), for: .touchUpInside)
        
        messageInputBar.leftStackView.alignment = .center
        messageInputBar.setLeftStackViewWidthConstant(to: 50, animated: true)
        messageInputBar.setStackViewItems([cameraItem], forStack: .left, animated: false)
        
        /// hidden avatar function
//        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
//            layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
//            layout.textMessageSizeCalculator.incomingAvatarSize = .zero
//        }
//        
//        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
//            layout.setMessageIncomingAvatarSize(.zero)
//            layout.setMessageOutgoingAvatarSize(.zero)
//        }
    }
    
    func reloadCollectionView() {
        messagesCollectionView.reloadData()
        messageInputBar.inputTextView.text = ""
        DispatchQueue.main.async { [weak self] in
            self?.messagesCollectionView.scrollToLastItem(at: .bottom, animated: true)
        }
    }
    
    func reloadAndKeepOffset() {
        messagesCollectionView.reloadDataAndKeepOffset()
    }
    
    func showAlert(title: String, message: String) {
        showAlert(title: title, message: message, OKcompletion: nil, CancelCompletion: nil)
    }
    
    func showTyping(chat: Chat) {
        if let message = chat.message(),
           !isFromCurrentSender(message: message) {
            setTypingIndicatorViewHidden(false, animated: true)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.setTypingIndicatorViewHidden(true, animated: true)
            self?.presenter?.typingIsStopped()
        }
    }
    
    func startLoader() {
        showLoaderIndicator()
    }
    
    func stopLoader() {
        dismissLoaderIndicator()
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        if offsetY < 0 {
            // User scrolled to the top, load more messages
            presenter?.didScroll()
        }
    }
    
    @objc private func moreDidPressed() {
        let alert = UIAlertController(title: "More", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Report", style: .destructive, handler: { [weak self] (act) in
            //report
        }))
        
        alert.addAction(UIAlertAction(title: "Block", style: .destructive, handler: { [weak self] (act) in
            //block
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true)
    }
    
    @objc private func cameraDidPressed() {
        let authorizedCamera = Permission.camera.authorized
        let authorizedPhotoLibrary = Permission.photoLibrary.authorized
        
        if !authorizedCamera {
            Permission.camera.request { [weak self] in
                debugLog("auth camera")
            }
            return
        }
        
        if !authorizedPhotoLibrary {
            Permission.photoLibrary.request { [weak self] in
                debugLog("auth photo lib")
            }
            return
        }
        
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
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
        presenter?.textViewTextDidChangeTo(text: text)
    }
}

extension ChatView: MessagesDataSource {
    var currentSender: SenderType {
        return presenter?.getSender() ?? ChatSender()
    }
    
    func isFromCurrentSender(message: MessageType) -> Bool {
        return presenter?.isFromCurrentSender(message: message) ?? false
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return presenter?.messageForItem(at: indexPath) ?? ChatMessage(kind: .text("Hello World"))
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return presenter?.numberOfSections() ?? 1
    }
    
    func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int {
        return presenter?.numberOfItems(inSection: section) ?? 1
    }
}

extension ChatView: MessagesDisplayDelegate {
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(corner, .curved)
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        switch message.kind {
        case .emoji( _):
            return .clear
        default:
            guard let dataSource = messagesCollectionView.messagesDataSource else { return UINCColor.bg_tertiary }
            return dataSource.isFromCurrentSender(message: message) ? UINCColor.primary : UINCColor.secondary
        }
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        guard let sender = message.sender as? ChatSender,
              let url_avatar = URL(string: sender.avatar) else { return }
        let avatar = Avatar(image: UIImage(symbol: .Person), initials: sender.displayName.initials)
        avatarView.isHidden = false
        avatarView.set(avatar: avatar)
        avatarView.circleCorner = true
        avatarView.kf.setImage(with: url_avatar)
        
        if(isFromCurrentSender(message: message)) {
            avatarView.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
    }
    
    func configureMediaMessageImageView(_ imageView: UIImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        switch message.kind {
        case .photo(let media):
            /// if we don't have a url, that means it's simply a pending message
            guard let url = media.url else {
                imageView.kf.indicator?.startAnimatingView()
                return
            }
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(with: url)
            imageView.contentMode = .scaleAspectFit
        default:
            break
        }
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return UINCColor.primary_foreground
    }
    
}

extension ChatView: MessagesLayoutDelegate {
    
}

extension ChatView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage { // 2
            presenter?.didPickImage(image: image)
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .pop,
           let _ = fromVC as? ChatView,
           let chats = toVC as? ChatsView {
            presenter?.didPop(to: chats)
        }
        return nil
    }
}
