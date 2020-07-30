//
//  LocalNotifications.swift
//  ezTask
//
//  Created by Mike Ovyan on 27.07.2020.
//  Copyright © 2020 Mike Ovyan. All rights reserved.
//

import Foundation
import UserNotifications

public func removeNotificationsById(id: String) {
    let ids = [id + "_1", id + "_2", id + "_3"]
    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ids) // delete old
    UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ids)
}

func setupReminder(task: TaskModel) {
    let content = UNMutableNotificationContent()
    content.title = task.mainText
    content.sound = .default
    content.categoryIdentifier = "Category"
    content.userInfo = ["id": task.id.uuidString]
    content.badge = 1 // TODO: fix
    let targetDate = task.alarmDate!
    scheduleNotification(targetDate: targetDate, content: content, id: task.id.uuidString)
}

func scheduleNotification(targetDate: Date, content: UNMutableNotificationContent, id: String) {
    let userInfo = content.userInfo
    let id = userInfo["id"] as! String
    removeNotificationsById(id: id)
    let ids = [id + "_1", id + "_2", id + "_3"]
    let targetDates = [targetDate, targetDate.addingTimeInterval(15 * 60), targetDate.addingTimeInterval(30 * 60)]
    for i in 0 ..< ids.count {
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: targetDates[i]), repeats: false)
        let request = UNNotificationRequest(identifier: ids[i], content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            if error != nil {
                print("Error with notifications")
            }
            })
    }
    let completeAction = UNNotificationAction(identifier: "Complete", title: "Complete", options: UNNotificationActionOptions(rawValue: 0))
    let postpone15MinAction = UNNotificationAction(identifier: "Postpone15Minutes", title: "Postpone by 15 minutes", options: UNNotificationActionOptions(rawValue: 0))
    let postpone30MinutesAction = UNNotificationAction(identifier: "Postpone30Minutes", title: "Postpone by 30 minutes", options: UNNotificationActionOptions(rawValue: 0))
    let category = UNNotificationCategory(identifier: "Category", actions: [completeAction, postpone15MinAction, postpone30MinutesAction], intentIdentifiers: [], options: .customDismissAction)
    UNUserNotificationCenter.current().setNotificationCategories([category])
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

func completeTaskFromNotification(notification: UNNotification) {
    let userInfo = notification.request.content.userInfo
    let id = userInfo["id"] as! String
    setDone(id: id, completion: {})
}

func postponeNotification(minutes: Double, notification: UNNotification) {
    scheduleNotification(targetDate: Date().addingTimeInterval(minutes * 60), content: notification.request.content.mutableCopy() as! UNMutableNotificationContent, id: notification.request.identifier)
}
