//
//  RtmService.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 23/06/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import Foundation
import AgoraUIKit
import AgoraRtmKit
//
//protocol RtmServiceDelegate: AnyObject {
//    func didReceiveMessageEvent(event: AgoraRtmMessageEvent)
//}
//
//class RtmService: NSObject, AgoraRtmClientDelegate {
//    static let shared: RtmService = RtmService()
//    private var rtmKit: AgoraRtmClientKit?
//    weak var delegate: RtmServiceDelegate?
//    
//    func initialize(config: AgoraRtmClientConfig) {
//        if rtmKit != nil {
//            debugLog("rtmKit already initialized")
//            return
//        }
//        rtmKit = AgoraRtmClientKit(config, delegate: self)
//    }
//    
//    func login(token: String?, completion: @escaping (Bool) -> Void) {
//        rtmKit?.login(token, completion: { [weak self] response, error in
//            if let res = response {
//                debugLog(res)
//            }
//            
//            if let err = error {
//                debugLog(err.localizedDescription)
//                debugLog(err)
//                completion(err.errorCode == .ok)
//            }
//        })
//    }
//    
//    func sendCallInvitation(channelName: String, message: String, completion: @escaping (Bool) -> Void) {
//        let opts = AgoraRtmPublishOptions()
//        opts.channelType = .message
//        rtmKit?.publish(channelName: channelName, message: message, option: opts, completion: { [weak self] response, error in
//            if let res = response {
//                debugLog(res)
//            }
//            
//            if let err = error {
//                debugLog(err.localizedDescription)
//                debugLog(err)
//                completion(err.errorCode == .ok)
//            }
//        })
//    }
//    
//    
//    func rtmKit(_ rtmKit: AgoraRtmClientKit, didReceiveMessageEvent event: AgoraRtmMessageEvent) {
//        if event.channelType == .message {
//            delegate?.didReceiveMessageEvent(event: event)
//        }
//    }
//}
