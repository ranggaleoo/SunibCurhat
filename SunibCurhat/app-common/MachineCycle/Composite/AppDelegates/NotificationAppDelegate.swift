//
//  NotificationAppDelegate.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 28/02/21.
//  Copyright © 2021 Rangga Leo. All rights reserved.
//

import UIKit
import Firebase

class NotificationAppDelegate: AppDelegateType {
    var gcmMessageIDKey = "gcm.message_id"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        Messaging.messaging().delegate = self
        requestPermissionNotification(application: application)
        application.registerForRemoteNotifications()
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let messageID = userInfo[gcmMessageIDKey] {
            debugLog("Message ID: \(messageID)")
        }
        debugLog(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
}

extension NotificationAppDelegate {
    private func requestPermissionNotification(application: UIApplication) {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
    }
}

extension NotificationAppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        RepoMemory.token_notif = fcmToken
        
        debugLog("Firebase registration token: \(fcmToken ?? "")")
        
        let dataDict:[String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }
}

extension NotificationAppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        let id = notification.request.identifier
        if let messageID = userInfo[gcmMessageIDKey] {
            debugLog("Message ID: \(messageID)")
        }
        debugLog(userInfo)
        debugLog("Received notification with ID = \(id)")
        completionHandler([])
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        let id = response.notification.request.identifier
        if let messageID = userInfo[gcmMessageIDKey] {
            debugLog("Message ID: \(messageID)")
        }
        debugLog(userInfo)
        debugLog("Received notification with ID = \(id)")
        completionHandler()
    }
}
