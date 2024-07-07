//
//  CallView.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 19/06/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import UIKit
import Foundation
import AgoraUIKit
import AgoraRtcKit
import AgoraRtmKit
import AgoraRtmControl

class CallView: UIViewController, CallPresenterToView {
    var presenter: CallViewToPresenter?
    
    var containerView: AgoraVideoViewer!
    
    init() {
        super.init(nibName: String(describing: CallView.self), bundle: Bundle(for: CallView.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.didLoad()
    }
    
    func setupViews() {
        guard let data = presenter?.getConnectionData(),
              let settings = presenter?.getSettings()
        else { return }
        containerView = AgoraVideoViewer(
            connectionData: data,
            style: .grid,
            agoraSettings: settings,
            delegate: self
        )
        
        containerView.fills(view: self.view)
        
        if let channel = presenter?.getChannel() {
            containerView.join(channel: channel, as: .broadcaster, fetchToken: true)
        }
    }
    
    @objc func endButtonHandler(_ sender: UIButton? = nil) {
        containerView.leaveChannel()
        presenter?.didEndCall()
    }
}

extension CallView: AgoraVideoViewerDelegate {
    func joinedChannel(channel: String) {
        debugLog("joinedChannel", channel)
    }
    
    func leftChannel(_ channel: String) {
        debugLog("leftChannel", channel)
    }
    
    func tokenWillExpire(_ engine: AgoraRtcEngineKit, tokenPrivilegeWillExpire token: String) {
        debugLog("tokenWillExpire", token)
    }
    
    func tokenDidExpire(_ engine: AgoraRtcEngineKit) {
        debugLog("tokenDidExpire")
    }
    
    func presentAlert(alert: UIAlertController, animated: Bool, viewer: UIView?) {
        debugLog("presentAlert", viewer)
    }
    
    func extraButtons() -> [UIButton] {
        let endButton = UIButton()
        endButton.setImage(
            UIImage(
                symbol: .Xmark,
                configuration: UIImage.SymbolConfiguration(scale: .large)
            ),
            for: .normal
        )
        endButton.backgroundColor = UINCColor.error
        endButton.tintColor = UINCColor.primary_foreground
        endButton.addTarget(self, action: #selector(endButtonHandler), for: .touchUpInside)
        return [endButton]
    }
    
    func incomingPongRequest(from peerId: String) {
        debugLog("incomingPongRequest", peerId)
    }
    
    func rtmStateChanged(from oldState: AgoraRtmController.RTMStatus, to newState: AgoraRtmController.RTMStatus) {
        debugLog("rtmStateChanged", oldState, newState)
    }
    
    func rtmChannelJoined(name: String, channel: AgoraRtmChannel, code: AgoraRtmJoinChannelErrorCode) {
        debugLog("rtmChannelJoined", name, channel, code)
    }
}
