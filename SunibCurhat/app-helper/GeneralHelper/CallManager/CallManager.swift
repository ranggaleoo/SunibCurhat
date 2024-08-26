//
//  CallManager.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 16/07/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import Foundation
import CallKit

class CallManager: NSObject {
    static let shared = CallManager()
    
    let callController = CXCallController()
    var provider: CXProvider
    
    private override init() {
        provider = CXProvider(configuration: CallManager.providerConfiguration)
        super.init()
        provider.setDelegate(self, queue: nil)
    }
    
    static var providerConfiguration: CXProviderConfiguration {
        let providerConfiguration = CXProviderConfiguration(localizedName: "Netijen Curhat")
        providerConfiguration.supportsVideo = true
        providerConfiguration.maximumCallsPerCallGroup = 1
        providerConfiguration.supportedHandleTypes = [.generic]
        return providerConfiguration
    }
    
    func reportIncomingCall(uuid: UUID, handle: String, hasVideo: Bool = false, completion: ((Error?) -> Void)? = nil) {
        let update = CXCallUpdate()
        update.remoteHandle = CXHandle(type: .generic, value: handle)
        update.hasVideo = hasVideo
        
        provider.reportNewIncomingCall(with: uuid, update: update) { error in
            completion?(error)
        }
    }
}

extension CallManager: CXProviderDelegate {
    func providerDidReset(_ provider: CXProvider) {
        debugLog("providerDidReset")
    }
    
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        debugLog(action)
        debugLog("CXAnswerCallAction")
        // Handle answering the call
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        debugLog(action)
        debugLog("CXEndCallAction")
        // Handle ending the call
        action.fulfill()
    }
}
