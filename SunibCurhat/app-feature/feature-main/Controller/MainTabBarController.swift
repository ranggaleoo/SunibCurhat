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
//        let vc = storyboad.instantiateViewController(withIdentifier: "nav_timeline")
        let vc = UINavigationController(rootViewController: FeedsRouter.createFeedsModule())
        var image: UIImage?
        if #available(iOS 13.0, *) {
            image = UIImage(symbol: .text_bubble_fill, configuration: nil)
        } else {
            image = UIImage(named: "bar_btn_timeline")
        }
        vc.tabBarItem = UITabBarItem(title: "Timeline", image: image, selectedImage: image)
        return vc
    }()
    
    private lazy var addThread: UIViewController = {
        let storyboad = UIStoryboard(name: "AddThread", bundle: nil)
        let vc = storyboad.instantiateViewController(withIdentifier: "nav_add_thread")
        var image: UIImage?
        if #available(iOS 13.0, *) {
            image = UIImage(symbol: .plus_bubble_fill, configuration: nil)
        } else {
            image = UIImage(named: "bar_btn_add_thread")
        }
        vc.tabBarItem = UITabBarItem(title: "Add Thread", image: image, selectedImage: image)
        return vc
    }()
    
    private lazy var chats: UIViewController = {
        let storyboad = UIStoryboard(name: "Chats", bundle: nil)
        let vc = storyboad.instantiateViewController(withIdentifier: "nav_chats")
        var image: UIImage?
        if #available(iOS 13.0, *) {
            image = UIImage(symbol: .double_bubble_fill, configuration: nil)
        } else {
            image = UIImage(named: "bar_btn_chats")
        }
        vc.tabBarItem = UITabBarItem(title: "Chats", image: image, selectedImage: image)
        return vc
    }()
    
    private lazy var premium: UIViewController = {
        let storyboad = UIStoryboard(name: "Premium", bundle: nil)
        let vc = storyboad.instantiateViewController(withIdentifier: "nav_premium")
        let image = UIImage(named: "bar_btn_premium")
        vc.tabBarItem = UITabBarItem(title: "Upgrade PRO", image: image, selectedImage: image)
        return vc
    }()
    
    private lazy var corona: UIViewController = {
        let storyboad = UIStoryboard(name: "Corona", bundle: nil)
        let vc = storyboad.instantiateViewController(withIdentifier: "nav_corona")
        var image: UIImage?
        if #available(iOS 13.0, *) {
            image = UIImage(symbol: .shield_checkmark_fill, configuration: nil)
        } else {
            image = UIImage(named: "bar_btn_corona")
        }
        vc.tabBarItem = UITabBarItem(title: "Covid-19", image: image, selectedImage: image)
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
        self.viewControllers = [timeline, chats]
        
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
                        print(e.localizedDescription)
                        self.dismissLoaderIndicator()
                        self.addObservers()
                        
                    case .success(let s):
                        self.dismissLoaderIndicator()
                        if s.success {
                            if let data = s.data {
                                let tmpToken = UDHelpers.shared.getString(key: .tmpToken)
                                if tmpToken != data["token"] {
                                    if (RepoMemory.user_name?.isEmpty ?? false) || RepoMemory.user_name == nil {
                                        RepoMemory.user_name = data["name"]
                                    }
                                    UDHelpers.shared.set(value: data["token"] ?? "", key: .tmpToken)
                                }
                                
                                RepoMemory.token = data["token"]
                                RepoMemory.pendingFunction?()
                                RepoMemory.pendingFunction = nil
                                
                                ConstGlobal.app_name            = data["app_name"]
                                ConstGlobal.contact_email       = data["contact_email"]
                                ConstGlobal.contact_whatsapp    = data["contact_whatsapp"]
                                ConstGlobal.contact_instagram   = data["contact_instagram"]
                                
                                if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                                    guard
                                        let version = Int(appVersion.replacingOccurrences(of: ".", with: "")),
                                        let versionServer = Int(data["version_ios"]?.replacingOccurrences(of: ".", with: "") ?? appVersion.replacingOccurrences(of: ".", with: "")),
                                        let urlUpdate = URL(string: data["url_update_version_ios"] ?? "")
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
                            }
                            
                        } else {
                            self.addObservers()
                        }
                    }
                })
                
            } else {
                print("Token available")
            }
        }))
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if
            let nav = timeline as? UINavigationController,
            let vc = nav.topViewController as? ListCurhatViewController,
            let title = item.title,
            title == "Timeline",
            selectedIndex == 0
        {
            DispatchQueue.main.async {
                vc.tableViewCurhat.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
        }
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
