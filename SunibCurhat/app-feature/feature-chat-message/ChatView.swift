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
    }
    
    func setupViews(name: String?) {
        title = name
        navigationDefault()
        
        // delegate
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        
        maintainPositionOnInputBarHeightChanged = true
        messageInputBar.inputTextView.tintColor = UINCColor.primary
        messageInputBar.sendButton.setTitleColor(UINCColor.primary, for: .normal)
        
        let cameraItem = InputBarButtonItem(type: .system)
        cameraItem.tintColor = UINCColor.tertiary
        cameraItem.image = UIImage(symbol: .CameraFill)
        cameraItem.setSize(CGSize(width: 60, height: 30), animated: true)
        
        messageInputBar.leftStackView.alignment = .center
        messageInputBar.setLeftStackViewWidthConstant(to: 50, animated: true)
        messageInputBar.setStackViewItems([cameraItem], forStack: .left, animated: false)
        
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
            layout.textMessageSizeCalculator.incomingAvatarSize = .zero
        }
        
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            layout.setMessageIncomingAvatarSize(.zero)
            layout.setMessageOutgoingAvatarSize(.zero)
        }
    }
    
    func reloadCollectionView() {
        messagesCollectionView.reloadData()
        messageInputBar.inputTextView.text = ""
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
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return UINCColor.primary_foreground
    }
    
}

extension ChatView: MessagesLayoutDelegate {
    
}
