//
//  CallPresenter.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 19/06/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import Foundation
import AgoraUIKit
import UIKit
import AgoraRtcKit
import AgoraRtmKit

class CallPresenter: NSObject, CallViewToPresenter {
    weak var view: CallPresenterToView?
    var interactor: CallPresenterToInteractor?
    var router: CallPresenterToRouter?
    var mediaConversation: MediaConversation?
    var callMediumType: CallMediumType?
    
    func didLoad() {
        interactor?.getAgoraToken(
            request: AgoraTokenRequest(
                tokenType: .rtc,
                channel: mediaConversation?.conversation_id ?? "",
                uid: mediaConversation?.user.user_id ?? "",
                role: mediaConversation?.role ?? .publisher,
                expire: nil
            )
        )
    }
    
    func didEndCall() {
        router?.navigateToParent(from: view)
    }
    
    func getConnectionData() -> AgoraConnectionData? {
        let appId = interactor?.getYekedoc()?.agora_app_id ?? ""
        let rtc_token = mediaConversation?.rtc_token
        let rtm_token = mediaConversation?.rtm_token
        var data = AgoraConnectionData(appId: appId, rtcToken: rtc_token, rtmToken: rtm_token)
//        data.username = mediaConversation?.user.user_id ?? ""
        return data
    }
    
    func getSettings() -> AgoraSettings? {
//        var colors = AgoraViewerColors(micFlag: .gray, micButtonNormal: .gray, camButtonNormal: .gray, micButtonSelected: .gray, camButtonSelected: .gray, buttonDefaultNormal: .gray, buttonDefaultSelected: .gray, buttonTintColor: .gray)
//        colors.buttonDefaultNormal = .gray.withAlphaComponent(0.5) as MPColor
//        colors.buttonDefaultSelected = .gray as MPColor
        
        var settings = AgoraSettings()
        settings.tokenURL = interactor?.getPreferences()?.urls?.agora_token_server
        settings.videoRenderMode = .hidden
//        settings.previewEnabled = callMediumType == .VideoCall
        settings.cameraEnabled = callMediumType == .VideoCall
        settings.rtcDelegate = self
        settings.rtmDelegate = self
        settings.rtmChannelDelegate = self
        settings.micEnabled = true
        settings.reportLocalVolume = true
        settings.rtmEnabled = true
        settings.usingDualStream = true
        settings.showRemoteRequestOptions = true
        
        settings.colors.buttonDefaultNormal = UINCColor.bg_primary.withAlphaComponent(0.2)
        settings.colors.buttonDefaultSelected = UINCColor.content_primary.withAlphaComponent(0.6)
        settings.colors.camButtonNormal = UINCColor.content_primary.withAlphaComponent(0.2)
        settings.colors.camButtonSelected = UINCColor.content_primary.withAlphaComponent(0.6)
        settings.colors.micButtonNormal = UINCColor.content_primary.withAlphaComponent(0.2)
        settings.colors.micButtonSelected = UINCColor.content_primary.withAlphaComponent(0.6)
        settings.colors.micFlag = UINCColor.error
        settings.colors.buttonTintColor = UINCColor.secondary_foreground
        
        switch callMediumType {
        case .VideoCall:
            settings.enabledButtons = [.cameraButton, .flipButton, .micButton]
        case .VoiceCall:
            settings.enabledButtons = [.cameraButton, .flipButton, .micButton]
        case nil:
            settings.enabledButtons = .all
        }
        return settings
    }
    
    func getChannel() -> String? {
        return mediaConversation?.conversation_id.sha256()
    }
}

extension CallPresenter: CallInteractorToPresenter {
    func didGetRtcToken(token: String?) {
        mediaConversation?.rtc_token = token
        interactor?.getAgoraToken(
            request: AgoraTokenRequest(
                tokenType: .rtm,
                channel: mediaConversation?.conversation_id ?? "",
                uid: mediaConversation?.user.user_id ?? "",
                role: mediaConversation?.role ?? .publisher,
                expire: nil
            )
        )
    }
    
    func didGetRtmToken(token: String?) {
        mediaConversation?.rtm_token = token
        view?.setupViews()
    }
    
    func failGetToken() {
        router?.navigateToParent(from: view)
    }
}

extension CallPresenter: AgoraRtcEngineDelegate {
    
}

extension CallPresenter: AgoraRtmDelegate {
    
}

extension CallPresenter: AgoraRtmChannelDelegate {
    
}
