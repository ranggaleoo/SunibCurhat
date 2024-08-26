// 
//  CallProtocols.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 19/06/24.
//  Copyright © 2024 Rangga Leo. All rights reserved.
//

import UIKit
import AgoraUIKit

// MARK: View -
protocol CallPresenterToView: AnyObject {
    var presenter: CallViewToPresenter? { get set }
    
    func setupViews()
}

// MARK: Interactor -
protocol CallPresenterToInteractor: AnyObject {
    var presenter: CallInteractorToPresenter?  { get set }
    
    func getYekedoc() -> Yekedoc?
    func getPreferences() -> Preferences?
    func getAgoraToken(request: AgoraTokenRequest)
    func call(call: Call)
}

// MARK: Router -
protocol CallPresenterToRouter: AnyObject {
    static func createCallModule(call: Call?, callType: Call.CallType?) -> UIViewController
    func navigateToParent(from: CallPresenterToView?)
}

// MARK: Presenter -
protocol CallViewToPresenter: AnyObject {
    var view: CallPresenterToView? {get set}
    var interactor: CallPresenterToInteractor? {get set}
    var router: CallPresenterToRouter? {get set}
    var call: Call? {get set}
    var callType: Call.CallType? {get set}
    
    func didLoad()
    func didEndCall()
    func getConnectionData() -> AgoraConnectionData?
    func getSettings() -> AgoraSettings?
    func getChannel() -> String?
}

protocol CallInteractorToPresenter: AnyObject {
    func didGetRtcToken(token: String?)
    func didGetRtmToken(token: String?)
    func failGetToken()
}
