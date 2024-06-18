// 
//  VoiceCallProtocols.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 15/06/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import UIKit

// MARK: View -
protocol VoiceCallPresenterToView: AnyObject {
    var presenter: VoiceCallViewToPresenter? { get set }
    
    func setupViews()
    func updateUIForJoinChannel()
    func updateUIForLeaveChannel()
}

// MARK: Interactor -
protocol VoiceCallPresenterToInteractor: AnyObject {
    var presenter: VoiceCallInteractorToPresenter?  { get set }
    
    func joinChannel()
    func leaveChannel()
}

// MARK: Router -
protocol VoiceCallPresenterToRouter: AnyObject {
    static func createVoiceCallModule(conversation: MediaConversation?) -> UIViewController
}

// MARK: Presenter -
protocol VoiceCallViewToPresenter: AnyObject {
    var view: VoiceCallPresenterToView? {get set}
    var interactor: VoiceCallPresenterToInteractor? {get set}
    var router: VoiceCallPresenterToRouter? {get set}
    var mediaConversation: MediaConversation? {get set}
    
    func didLoad()
    func joinCall()
    func leaveCall()
}

protocol VoiceCallInteractorToPresenter: AnyObject {
    func didJoinChannel()
    func didLeaveChannel()
}
