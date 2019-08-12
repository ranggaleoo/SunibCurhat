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
        let image = UIImage(named: "tab_gold_dashboard")
        vc.tabBarItem = UITabBarItem(title: "Timeline", image: image, selectedImage: image)
        return vc
    }()
    
    private lazy var addThread: UIViewController = {
        let storyboad = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboad.instantiateViewController(withIdentifier: "empty")
        let image = UIImage(named: "tab_gold_subscription")
        vc.tabBarItem = UITabBarItem(title: "Add Thread", image: image, selectedImage: image)
        return vc
    }()
    
    private lazy var chats: UIViewController = {
        let storyboad = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboad.instantiateViewController(withIdentifier: "empty")
        let image = UIImage(named: "tab_gold_marketplace")
        vc.tabBarItem = UITabBarItem(title: "Chats", image: image, selectedImage: image)
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.isOpaque = false
        self.tabBar.isTranslucent = false
        self.tabBar.tintColor = UIColor.custom.red
        self.tabBar.barTintColor = UIColor.white
        self.tabBar.unselectedItemTintColor = UIColor.lightGray
        self.viewControllers = [timeline, addThread, chats]
        
        self.selectedIndex = 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
