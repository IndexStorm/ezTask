//
//  AppDelegate.swift
//  ezTask
//
//  Created by Mike Ovyan on 17.07.2020.
//  Copyright © 2020 Mike Ovyan. All rights reserved.
//

import AVFoundation
import CoreData
import SideMenu
import UIKit
import Amplitude

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    lazy var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        checkNotifications()
        setupWindow()
        setupAnalytics()
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default, options: AVAudioSession.CategoryOptions.mixWithOthers)
        } catch { print(error.localizedDescription) }
        return true
    }

    // MARK: - Private

    private func setupWindow() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController()
        let mainViewController = MainVC()
        navigationController.viewControllers = [mainViewController]
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        sendMorningReminder()
        if UserDefaults.standard.bool(forKey: "badgeToday") {
            let newBadge = fetchAllTasks().tasksForToday().allUndoneTasks().count
            UIApplication.shared.applicationIconBadgeNumber = newBadge
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        sendMorningReminder()
    }

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        if !UserDefaults.standard.bool(forKey: "badgeToday") {
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case "Complete":
            completeTaskFromNotification(notification: response.notification)
        case "Postpone15Minutes":
            postponeNotification(minutes: 15, notification: response.notification)
        case "Postpone30Minutes":
            postponeNotification(minutes: 30, notification: response.notification)
        default:
            print("Unknown action")
        }
        completionHandler()
    }
    
    func setupAnalytics() {
        // Enable sending automatic session events
        Amplitude.instance()?.trackingSessionEvents = true
        // Initialize SDK
        Amplitude.instance()?.initializeApiKey("cd2eca0f5b5a9000d543bd83848f9a58")
        // Log an event
        Amplitude.instance()?.logEvent("app_start")
    }
}
