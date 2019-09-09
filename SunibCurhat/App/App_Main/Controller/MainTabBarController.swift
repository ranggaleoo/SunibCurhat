//
//  MainTabBarController.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 04/08/19.
//  Copyright © 2019 Rangga Leo. All rights reserved.
//

import Foundation
import UIKit
import Firebase

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
        let storyboad = UIStoryboard(name: "Chats", bundle: nil)
        let vc = storyboad.instantiateViewController(withIdentifier: "nav_chats")
        let image = UIImage(named: "bar_btn_chats")
        vc.tabBarItem = UITabBarItem(title: "Chats", image: image, selectedImage: image)
        return vc
    }()
    
    private var observer: [NSObjectProtocol] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.isOpaque = false
        self.tabBar.isTranslucent = false
        self.tabBar.tintColor = UIColor.custom.blue_absolute
        self.tabBar.barTintColor = UIColor.white
        self.tabBar.unselectedItemTintColor = UIColor.custom.gray_absolute
        self.viewControllers = [timeline, addThread, chats]
        
        self.selectedIndex = 0
        self.addObservers()
        RepoMemory.token = nil
    }
    
    private func addObservers() {
        observer.forEach { (notif) in
            NotificationCenter.default.removeObserver(notif)
        }
        observer.removeAll()
        
        observer.append(NotificationCenter.default.addObserver(forName: .tokenIsChanged, object: nil, queue: .some(.main), using: { (n) in
            if RepoMemory.token == nil {
                self.showLoaderIndicator()
                MainService.shared.getToken(completion: { (result) in
                    switch result {
                    case .failure(let e):
                        self.dismissLoaderIndicator()
                        self.addObservers()
//                        self.showAlert(title: "Session Expire", message: e.localizedDescription + "\n Try Again?", OKcompletion: { (act) in
//                            self.addObservers()
//                        }, CancelCompletion: nil)
                        
                    case .success(let s):
                        self.dismissLoaderIndicator()
                        if s.success {
                            if let data = s.data {
                                RepoMemory.token        = data["token"]
                                RepoMemory.user_name    = data["name"]
                                RepoMemory.pendingFunction?()
                                RepoMemory.pendingFunction = nil
//                                self.showAlert(title: "Session has been updated", message: s.message + "\n Try Again?", OKcompletion: { (act) in
//                                    RepoMemory.pendingFunction?()
//                                    RepoMemory.pendingFunction = nil
//                                }, CancelCompletion: nil)
                                
                                if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                                    guard
                                        let version = Int(appVersion.replacingOccurrences(of: ".", with: "")),
                                        let versionServer = Int(data["version"]?.replacingOccurrences(of: ".", with: "") ?? appVersion.replacingOccurrences(of: ".", with: "")),
                                        let urlUpdate = URL(string: data["url_update_version"] ?? "")
                                    else {
                                        return
                                    }
                                    
                                    if version < versionServer {
                                        self.showAlert(title: "New Version Available", message: "Please, update app to new version to continue tell what in your heart :)", OKcompletion: { (act) in
                                            if UIApplication.shared.canOpenURL(urlUpdate) {
                                                UIApplication.shared.open(urlUpdate, options: [:], completionHandler: { (clicked) in
                                                    if clicked {
                                                        print("-----user will update version")
                                                    }
                                                })
                                            }
                                        }, CancelCompletion: nil)
                                    }
                                }
                            
                            } else {
                                self.addObservers()
//                                self.showAlert(title: "Session Expire", message: "token not found \n Try Again?", OKcompletion: { (act) in
//                                    self.addObservers()
//                                }, CancelCompletion: nil)
                            }
                            
                        } else {
                            self.addObservers()
//                            self.showAlert(title: "Session Expire", message: s.message + "\n Try Again?", OKcompletion: { (act) in
//                                self.addObservers()
//                            }, CancelCompletion: nil)
                        }
                    }
                })
                
            } else {
                print("Token available")
            }
        }))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        observer.forEach { (notification) in
            NotificationCenter.default.removeObserver(notification)
        }
        observer.removeAll()
    }
}
