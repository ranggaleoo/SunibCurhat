// 
//  CallInteractor.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 19/06/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import Foundation

class CallInteractor: CallPresenterToInteractor {
    weak var presenter: CallInteractorToPresenter?
    
    func call(call: Call) {
        SocketService.shared.emit(.req_call, call) { [weak self] (result) in
            switch result {
            case .success():
                debugLog("success send call")
            case .failure(let err):
                debugLog(err.localizedDescription)
            }
        }
    }
    
    func getAgoraToken(request: AgoraTokenRequest) {
        MainService.shared.getAgoraToken(request: request) { [weak self] result in
            switch result {
            case .success(let res):
                switch request.tokenType {
                case .rtc:
                    self?.presenter?.didGetRtcToken(token: res.token)
                case .rtm:
                    self?.presenter?.didGetRtmToken(token: res.token)
                default:
                    break
                }
            case .failure(let err):
                debugLog(err)
                self?.presenter?.failGetToken()
            }
        }
    }
    
    func getYekedoc() -> Yekedoc? {
        if let preferences = UDHelpers.shared.getObject(type: Preferences.self, forKey: .preferences_key),
           let yekedocString = preferences.yekedoc,
           let yekedocData = Data(base64Encoded: yekedocString),
           let yekedoc = try? JSONDecoder().decode(Yekedoc.self, from: yekedocData) {
            return yekedoc
        }
        return nil
    }
    
    func getPreferences() -> Preferences? {
        return UDHelpers.shared.getObject(type: Preferences.self, forKey: .preferences_key)
    }
}
