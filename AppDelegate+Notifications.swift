//
//  AppDelegate+Notifications.swift
//  TutorHubb
//
//  Created by Akash Soni on 1/26/21.
//  Copyright © 2021 codefonsi. All rights reserved.
//
//1. setup from devloper.apple.com
//2. setup xcode by adding push notifications 
// 3. follow the steps 

import Foundation
enum Identifiers {
    static let viewAction = "VIEW_IDENTIFIER"
    static let newCategory = "NEW_CATEGORY"
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    // if app is not running then go to application didlaunching with option
    /*
     func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
         // Override point for customization after application launch.
         UNUserNotificationCenter.current().delegate = self
         registerForPushNotifications()
         let notificationOption = launchOptions?[.remoteNotification]

         if
           let notification = notificationOption as? [String: AnyObject],
           let aps = notification["aps"] as? [String: AnyObject] {
           //(window?.rootViewController as? UITabBarController)?.selectedIndex = 1
         }
     }
     */
    //if app is in backgroupng or in running state
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        guard let aps = userInfo["aps"] as? [String: AnyObject] else {
            completionHandler(.failed)
            return
        }
        /*
         access data after receiveing notification
         if aps["content-available"] as? Int == 1 {
             let podcastStore = PodcastStore.sharedStore
             podcastStore.refreshItems { didLoadNewItems in
                 completionHandler(didLoadNewItems ? .newData : .noData)
             }
         } else {
             NewsItem.makeNewsItem(aps)
             completionHandler(.newData)
         }
         
         */
    }
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, error in
                print("Permission granted: \(granted)")
                guard granted else { return }
                let viewAction = UNNotificationAction(
                    identifier: Identifiers.viewAction,
                    title: "View",
                    options: [.foreground])
                let newsCategory = UNNotificationCategory(
                    identifier: Identifiers.newCategory,
                    actions: [viewAction],
                    intentIdentifiers: [],
                    options: []
                )
                UNUserNotificationCenter.current().setNotificationCategories([newsCategory])
                self?.getNotificationSettings()
            }
    }
    
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        
        if let aps = userInfo["aps"] as? [String: AnyObject]{
            // add action on view tap, like open in app safari
            print("View tapped \(aps)")
        }
        completionHandler()
    }
}
