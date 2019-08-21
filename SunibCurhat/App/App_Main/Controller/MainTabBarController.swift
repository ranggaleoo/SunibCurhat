//
//  MainTabBarController.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 04/08/19.
//  Copyright © 2019 Rangga Leo. All rights reserved.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    private lazy var timeline: UIViewController = {
        let storyboad = UIStoryboard(name: "ListCurhat", bundle: nil)
        let vc = storyboad.instantiateViewController(withIdentifier: "nav_timeline")
        let image = UIImage(named: "bar_btn_timeline")
        vc.tabBarItem = UITabBarItem(title: "Timeline", image: image, selectedImage: image)
        return vc
    }()
    
    private lazy var addThread: UIViewController = {
        let storyboad = UIStoryboard(name: "AddThread", bundle: nil)
        let vc = storyboad.instantiateViewController(withIdentifier: "nav_add_thread")
        let image = UIImage(named: "bar_btn_add_thread")
        vc.tabBarItem = UITabBarItem(title: "Add Thread", image: image, selectedImage: image)
        return vc
    }()
    
    private lazy var chats: UIViewController = {
        let storyboad = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboad.instantiateViewController(withIdentifier: "empty")
        let image = UIImage(named: "bar_btn_chats")
        vc.tabBarItem = UITabBarItem(title: "Chats", image: image, selectedImage: image)
        return vc
    }()
    
    private var observer: NSObjectProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.isOpaque = false
        self.tabBar.isTranslucent = false
        self.tabBar.tintColor = UIColor.custom.blue_absolute
        self.tabBar.barTintColor = UIColor.white
        self.tabBar.unselectedItemTintColor = UIColor.custom.gray_absolute
        self.viewControllers = [timeline, addThread, chats]
        
        self.selectedIndex = 0
        self.getToken()
    }
    
    private func getToken() {
        observer = NotificationCenter.default.addObserver(forName: .tokenIsChanged, object: nil, queue: .some(.main), using: { (n) in
            if RepoMemory.token == nil {
                self.showLoaderIndicator()
                MainService.shared.getToken(completion: { (result) in
                    switch result {
                    case .failure(let e):
                        self.dismissLoaderIndicator()
                        self.showAlert(title: "Error", message: e.localizedDescription + "\n Try Again?", OKcompletion: { (act) in
                            self.getToken()
                        }, CancelCompletion: nil)
                        
                    case .success(let s):
                        self.dismissLoaderIndicator()
                        if s.success {
                            if let data = s.data {
                                RepoMemory.token = data["token"]
                                self.showAlert(title: "Success", message: s.message, OKcompletion: nil, CancelCompletion: nil)
                            
                            } else {
                                self.showAlert(title: "Error", message: "token not found \n Try Again?", OKcompletion: { (act) in
                                    self.getToken()
                                }, CancelCompletion: nil)
                            }
                            
                        } else {
                            self.showAlert(title: "Error", message: s.message + "\n Try Again?", OKcompletion: { (act) in
                                self.getToken()
                            }, CancelCompletion: nil)
                        }
                    }
                })
                
            } else {
                print("Token available")
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(observer)
    }
}
