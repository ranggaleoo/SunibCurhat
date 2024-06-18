//
//  VoiceCallPresenter.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 15/06/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import Foundation

class VoiceCallPresenter: VoiceCallViewToPresenter {
    weak var view: VoiceCallPresenterToView?
    var interactor: VoiceCallPresenterToInteractor?
    var router: VoiceCallPresenterToRouter?
    var mediaConversation: MediaConversation?
    
    func didLoad() {
        debugLog(mediaConversation)
        view?.setupViews()
    }
    
    func joinCall() {
        interactor?.joinChannel()
    }
    
    func leaveCall() {
        interactor?.leaveChannel()
    }
}

extension VoiceCallPresenter: VoiceCallInteractorToPresenter {
    func didJoinChannel() {
        view?.updateUIForJoinChannel()
    }
    
    func didLeaveChannel() {
        view?.updateUIForLeaveChannel()
    }
}
