// 
//  VoiceCallInteractor.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 15/06/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import Foundation
import AgoraRtcKit

class VoiceCallInteractor: NSObject, VoiceCallPresenterToInteractor {
    weak var presenter: VoiceCallInteractorToPresenter?
    var agoraEngine: AgoraRtcEngineKit?
    
    override init() {
        super.init()
        let config = AgoraRtcEngineConfig()
        config.appId = "11cd00539c0749fd8c5be43b0ef70eeb"
        agoraEngine = AgoraRtcEngineKit.sharedEngine(with: config, delegate: self)
    }
    
    func joinChannel() {
        agoraEngine?.joinChannel(byToken: nil, channelId: "abcd", info: nil, uid: 0, joinSuccess: { [weak self] success, pint3, pint in
            debugLog(pint3)
            debugLog(pint)
            debugLog(success)
            self?.presenter?.didJoinChannel()
        })
    }
    
    func leaveChannel() {
        agoraEngine?.leaveChannel()
        presenter?.didLeaveChannel()
    }
}

extension VoiceCallInteractor: AgoraRtcEngineDelegate {
    
    
}
