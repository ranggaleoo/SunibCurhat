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
    
    private let outgoingAvatarOverlap: CGFloat = 17.5
    
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
        let moreButtonItem = UIBarButtonItem(image: UIImage(symbol: .Ellipsis, configuration: .init(pointSize: 12, weight: .regular)), style: .plain, target: self, action: #selector(moreDidPressed))
        let voiceCallButtonItem = UIBarButtonItem(image: UIImage(symbol: .PhoneFill, configuration: .init(pointSize: 12, weight: .regular)), style: .plain, target: self, action: #selector(voiceCallDidPressed))
        let videoCallButtonItem = UIBarButtonItem(image: UIImage(symbol: .VideoFill, configuration: .init(pointSize: 12, weight: .regular)), style: .plain, target: self, action: #selector(videoCallDidPressed))
        navigationItem.rightBarButtonItems = [moreButtonItem, voiceCallButtonItem, videoCallButtonItem]
        
        /// delegate
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        navigationController?.delegate = self
        
        maintainPositionOnInputBarHeightChanged = true
        
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
    
    func updateInputBarToBlocked(name: String?) {
        if presenter?.getStateBlocked() ?? false {
            let blockInputView = UIView()
            blockInputView.backgroundColor = UINCColor.bg_secondary
            var blockLabel: UILabel = UILabel()
            if presenter?.getStateBlockedByMe() ?? false {
                let blockClickableLabel = UINCLabelClickable()
                blockClickableLabel.numberOfLines = 0
                blockClickableLabel.textAlignment = .center
                blockClickableLabel.text = "You have blocked this account. Unblock"
                blockClickableLabel.clickables["Unblock"] = { [weak self] in
                    self?.presenter?.didTapBlock(block: false)
                }
                blockLabel = blockClickableLabel
                blockInputView.addSubview(blockLabel)
            } else {
                let blocked_by_name = name ?? "this Account"
                let blockBodyLabel = UINCLabelBody()
                blockBodyLabel.numberOfLines = 0
                blockBodyLabel.textAlignment = .center
                blockBodyLabel.text = "You have been blocked by \(blocked_by_name)"
                blockLabel = blockBodyLabel
                blockInputView.addSubview(blockLabel)
            }
            
            blockLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
              blockLabel.topAnchor.constraint(equalTo: blockInputView.topAnchor, constant: 16),
              blockLabel.bottomAnchor.constraint(equalTo: blockInputView.safeAreaLayoutGuide.bottomAnchor, constant: -16),
              blockLabel.leadingAnchor.constraint(equalTo: blockInputView.leadingAnchor),
              blockLabel.trailingAnchor.constraint(equalTo: blockInputView.trailingAnchor),
            ])
            
            inputBarType = .custom(blockInputView)
            
        } else {
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
            
            inputBarType = .messageInputBar
        }
    }
    
    func updateUserStatusConnection(name: String?, status: String?) {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: -2, width: 0, height: 0))
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.text = name
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.sizeToFit()
        
        let subtitleLabel = UILabel(frame: CGRect(x: 0, y: 18, width: 0, height: 0))
        subtitleLabel.font = UIFont.systemFont(ofSize: 12)
        subtitleLabel.text = status
        subtitleLabel.textAlignment = .center
        subtitleLabel.adjustsFontSizeToFitWidth = true
        subtitleLabel.sizeToFit()
        
        let titleView =
        UIView(frame: CGRect(x: 0, y: 0, width: max(titleLabel.frame.size.width, subtitleLabel.frame.size.width), height: 30))
        titleView.addSubview(titleLabel)
        if status != nil {
            titleView.addSubview(subtitleLabel)
        } else {
            titleLabel.frame = titleView.frame
        }
        let widthDiff = subtitleLabel.frame.size.width - titleLabel.frame.size.width
        if widthDiff < 0 {
            let newX = widthDiff / 2
            subtitleLabel.frame.origin.x = abs(newX)
        } else {
            let newX = widthDiff / 2
            titleLabel.frame.origin.x = newX
        }
        
        navigationItem.titleView = titleView
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
        /// to-do
        /// add validation if latest cell is visible on cell, do scroll except not.
        if let message = chat.message(),
           !isFromCurrentSender(message: message) {
            setTypingIndicatorViewHidden(false, animated: true) { [weak self] success in
                if success {
                    self?.messagesCollectionView.scrollToLastItem()
                }
            }
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
    
    override func scrollViewDidEndDecelerating(_: UIScrollView) {
        presenter?.didVisibleChatsAsRead(indexPaths: messagesCollectionView.indexPathsForVisibleItems)
    }
    
    override func scrollViewDidEndDragging(_: UIScrollView, willDecelerate declarate: Bool) {
        if !declarate {
            presenter?.didVisibleChatsAsRead(indexPaths: messagesCollectionView.indexPathsForVisibleItems)
        }
    }
    
    @objc private func videoCallDidPressed() {
        let authorizedCamera = Permission.camera.authorized
        let authorizedMicrophone = Permission.microphone.authorized
        
        if !authorizedCamera {
            Permission.camera.request { [weak self] in
                debugLog("auth camera")
            }
            return
        }
        
        if !authorizedMicrophone {
            Permission.microphone.request { [weak self] in
                debugLog("auth microphone")
            }
            return
        }
    }
    
    @objc private func voiceCallDidPressed() {
        let authorizedMicrophone = Permission.microphone.authorized
                
        if !authorizedMicrophone {
            Permission.microphone.request { [weak self] in
                debugLog("auth microphone")
            }
            return
        }
        
        presenter?.didTapVoiceCall()
    }
    
    @objc private func moreDidPressed() {
        let alert = UIAlertController(title: "More", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Report", style: .destructive, handler: { [weak self] (act) in
            self?.presenter?.didTapReport()
        }))
        
        if presenter?.getStateBlocked() ?? false {
            if presenter?.getStateBlockedByMe() ?? false {
                alert.addAction(UIAlertAction(title: "Unblock", style: .destructive, handler: { [weak self] (act) in
                    self?.presenter?.didTapBlock(block: false)
                }))
            } else {
                /// nothing
            }
        } else {
            alert.addAction(UIAlertAction(title: "Block", style: .destructive, handler: { [weak self] (act) in
                self?.presenter?.didTapBlock(block: true)
            }))
        }
        
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
    
    func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        var dateString = ""
        
        if isFromCurrentSender(message: message), presenter?.isReadMessage(at: indexPath) ?? false {
            dateString += "read • "
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateString += dateFormatter.string(from: message.sentDate)
        
        if let isNext = presenter?.isNextMessageSameSender(at: indexPath),
           isNext {
            return nil
        }
        
        return NSAttributedString(string: dateString, attributes: [.font: UIFont.systemFont(ofSize: 10), .foregroundColor: UINCColor.content_secondary])
    }
}

extension ChatView: MessagesDisplayDelegate {
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        var messageBubble: MessageStyle = .bubble
        if isFromCurrentSender(message: message) {
            messageBubble = .bubbleTail(.bottomRight, .curved)
            if let isNext = presenter?.isNextMessageSameSender(at: indexPath),
               isNext {
                messageBubble = .bubble
            }
        } else {
            messageBubble = .bubbleTail(.bottomLeft, .curved)
            if let isNext = presenter?.isNextMessageSameSender(at: indexPath),
               isNext {
                messageBubble = .bubble
            }
        }
        return messageBubble
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
        avatarView.isHidden = presenter?.isNextMessageSameSender(at: indexPath) ?? false
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
    
    func enabledDetectors(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> [DetectorType] {
        return [.address, .phoneNumber, .date, .transitInformation, .url, .hashtag, .mention]
    }
    
    func detectorAttributes(for detector: DetectorType, and message: MessageType, at indexPath: IndexPath) -> [NSAttributedString.Key : Any] {
        return [
            .foregroundColor: UINCColor.primary_foreground,
            .underlineColor: UINCColor.primary_foreground,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
    }    
}

extension ChatView: MessagesLayoutDelegate {
    func cellBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if let isNext = presenter?.isNextMessageSameSender(at: indexPath),
           isNext {
            return 0
        }
        return 20
    }
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
