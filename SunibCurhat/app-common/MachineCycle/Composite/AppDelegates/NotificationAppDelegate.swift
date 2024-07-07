//
//  NotificationAppDelegate.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 28/02/21.
//  Copyright © 2021 Rangga Leo. All rights reserved.
//

import UIKit
import FirebaseMessaging
import PushKit

class NotificationAppDelegate: AppDelegateType {
    var gcmMessageIDKey = "gcm.message_id"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // delegte push notification
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
        
        // request pushh notification permission
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )
        
        // register push notification
        application.registerForRemoteNotifications()
        
        // setup voip pushkit notification
        let pushRegistry = PKPushRegistry(queue: .main)
        pushRegistry.delegate = self
        pushRegistry.desiredPushTypes = [.voIP]
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        debugLog(error.localizedDescription)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let messageID = userInfo[gcmMessageIDKey] {
            debugLog("Message ID: \(messageID)")
        }
        debugLog(userInfo)
        let pushIsOn = ConstGlobal.setting_list.get(.pushNotification)?.usersValue ?? false
        completionHandler(UIBackgroundFetchResult.newData)
    }
}

extension NotificationAppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let token = fcmToken,
           var user = UDHelpers.shared.getObject(type: User.self, forKey: .user) {
            user.fcm_token = token
            MainService.shared.saveToken(user: user) { [weak self] result in
                switch result {
                case .success(let res):
                    debugLog("save token: \(res.data)")
                case .failure(let err):
                    debugLog("save token: \(err.localizedDescription)")
                }
            }
        }
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
        let pushIsOn = ConstGlobal.setting_list.get(.pushNotification)?.usersValue ?? false
        completionHandler([.sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        let id = response.notification.request.identifier
        if let messageID = userInfo[gcmMessageIDKey] {
            debugLog("Message ID: \(messageID)")
        }
        debugLog(userInfo)
        debugLog("Received notification with ID = \(id)")
        let pushIsOn = ConstGlobal.setting_list.get(.pushNotification)?.usersValue ?? false
        completionHandler()
    }
}

extension NotificationAppDelegate: PKPushRegistryDelegate {
    func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
        if var user = UDHelpers.shared.getObject(type: User.self, forKey: .user) {
            let token = pushCredentials.token.base64EncodedString()
            user.pushkit_token = token
            MainService.shared.saveToken(user: user) { [weak self] result in
                switch result {
                case .success(let res):
                    debugLog("save token: \(res.data)")
                case .failure(let err):
                    debugLog("save token: \(err.localizedDescription)")
                }
            }
        }
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
        // Handle the incoming VoIP push notification
        // Show an incoming call screen
        completion()
    }
}
