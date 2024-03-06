//
//  StartupAppDelegate.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 28/02/21.
//  Copyright © 2021 Rangga Leo. All rights reserved.
//

import UIKit

class StartupAppDelegate: AppDelegateType {
    var window: UIWindow?
    
    init(window: UIWindow? = nil) {
        self.window = window
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        let controller = getInitial()
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.navigationBar.isHidden = true
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
}

extension StartupAppDelegate {
    private func getInitial() -> UIViewController {
        SplashRouter.createSplashModule(secondaryBackground: nil)
//        ProfileRouter.createProfileModule()
//        ChatRouter.createChatModule()
    }
}
