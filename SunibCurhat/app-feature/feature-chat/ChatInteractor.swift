// 
//  ChatInteractor.swift
//  SunibCurhat
//
//  Created by Developer on 20/03/21.
//  Copyright © 2021 Rangga Leo. All rights reserved.
//

import Kingfisher

class ChatInteractor: ChatPresenterToInteractor {
    weak var presenter: ChatInteractorToPresenter?
    
    
    func listenMessage(chatID: String) {
    
    }
    
    func saveMessage(message: Message) {
        
    }
    
    func sendNotif(token: String, title: String, body: String) {
        MainService.shared.sendNotif(title: title, text: body, fcmToken: token, completion: { (result) in
            switch result {
            case .failure(let e):
                debugLog(e.localizedDescription)
            case .success(let s):
                debugLog(s)
            }
        })
    }
    
    func uploadImage(message: Message, imageData: Data, chatID: String, isSendingImage: Bool) {
       
    }
    
    private func downloadImage(at url: URL, completion: @escaping (UIImage?) -> Void) {
        
    }
    
    deinit {

    }
}
