// 
//  ChatProtocols.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 11/03/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import UIKit
import MessageKit
import Cloudinary

// MARK: View -
protocol ChatPresenterToView: AnyObject {
    var presenter: ChatViewToPresenter? { get set }
    
    func setupViews(name: String?)
    func updateInputBarToBlocked(name: String?)
    func updateUserStatusConnection(name: String?, status: String?)
    func updateCallButton(isCallable: Bool?)
    func reloadCollectionView()
    func reloadAndKeepOffset()
    func showAlert(title: String, message: String)
    func showAlertRequestCall(title: String, message: String)
    func showBottomSheetRequestCall(conversation: Conversation?, isFromCurrentSender: Bool?, isCallable: Bool?)
    func showTyping(chat: Chat)
    func startLoader()
    func stopLoader()
    func dismissBottomSheet()
}

// MARK: Interactor -
protocol ChatPresenterToInteractor: AnyObject {
    var presenter: ChatInteractorToPresenter?  { get set }
    
    func getChats(request: RequestChats)
    func sendChat(chat: Chat)
    func typing(chat: Chat)
    func uploadImage(image: UIImage)
    func updateBlock(conversation: Conversation)
    func markAsRead(chats: [Chat])
    func requestCall(conversation: Conversation)
    func authorizeCall(conversation: Conversation)
}

// MARK: Router -
protocol ChatPresenterToRouter: AnyObject {
    static func createChatModule(conversation: Conversation?) -> MessagesViewController
    func navigateToChats(to: ChatsPresenterToView?, conversation: Conversation?)
    func navigateToReport(chat: Chat, from: ChatPresenterToView?)
    func navigateToCall(from: ChatPresenterToView?, conversation: MediaConversation?, medium: CallMediumType?)
}

// MARK: Presenter -
protocol ChatViewToPresenter: AnyObject {
    var view: ChatPresenterToView? {get set}
    var interactor: ChatPresenterToInteractor? {get set}
    var router: ChatPresenterToRouter? {get set}
    
    func didLoad()
    func didScroll()
    func didPop(to: ChatsPresenterToView)
    func didPickImage(image: UIImage)
    func didTapBlock(block: Bool)
    func didTapReport()
    func didTapCall(medium: CallMediumType)
    func didTapRequestAuthorizeCall()
    func didTapAuthorizeCall(accept: Bool)
    func didVisibleChatsAsRead(indexPaths: [IndexPath])
    func set(conversation: Conversation?)
    func typingIsStopped()
    
    // input bar
    func didPressSendButtonWith(text: String)
    func textViewTextDidChangeTo(text: String)
    
    // data source
    func getStateBlocked() -> Bool
    func getStateBlockedByMe() -> Bool
    func getSender() -> SenderType?
    func isFromCurrentSender(message: MessageType) -> Bool
    func isPreviousMessageSameSender(at indexPath: IndexPath) -> Bool
    func isNextMessageSameSender(at indexPath: IndexPath) -> Bool
    func isReadMessage(at indexPath: IndexPath) -> Bool
    func messageForItem(at indexPath: IndexPath) -> MessageType?
    func numberOfSections() -> Int?
    func numberOfItems(inSection section: Int) -> Int?
}

protocol ChatInteractorToPresenter: AnyObject {
    func failSendChat(message: String)
    func didUploadImage(response: CLDUploadResult?)
    func failUploadImage(message: String)
    func failUpdateBlockUser(message: String)
    func failingRequestCall(messagge: String)
    func failAuthorizeCall(message: String)
}
