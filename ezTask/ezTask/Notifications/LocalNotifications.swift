//
//  LocalNotifications.swift
//  ezTask
//
//  Created by Mike Ovyan on 27.07.2020.
//  Copyright © 2020 Mike Ovyan. All rights reserved.
//

import Foundation
import UserNotifications

var notificationsStatus: UNAuthorizationStatus = .notDetermined

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
    if !UserDefaults.standard.bool(forKey: "badgeToday") {
        content.badge = 1 // TODO: fix
    }
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
    let completeAction = UNNotificationAction(identifier: "Complete", title: "label.complete".localized, options: UNNotificationActionOptions(rawValue: 0))
    let postpone15MinAction = UNNotificationAction(identifier: "Postpone15Minutes", title: "Remind in 15 minutes".localized, options: UNNotificationActionOptions(rawValue: 0))
    let postpone30MinutesAction = UNNotificationAction(identifier: "Postpone30Minutes", title: "Remind in 30 minutes".localized, options: UNNotificationActionOptions(rawValue: 0))
    let category = UNNotificationCategory(identifier: "Category", actions: [completeAction, postpone15MinAction, postpone30MinutesAction], intentIdentifiers: [], options: .customDismissAction)
    UNUserNotificationCenter.current().setNotificationCategories([category])
}

func completeTaskFromNotification(notification: UNNotification) {
    let userInfo = notification.request.content.userInfo
    let id = userInfo["id"] as! String
    setDone(id: id, completion: {})
}

func postponeNotification(minutes: Double, notification: UNNotification) {
    scheduleNotification(targetDate: Date().addingTimeInterval(minutes * 60), content: notification.request.content.mutableCopy() as! UNMutableNotificationContent, id: notification.request.identifier)
}

func checkNotifications() {
    UNUserNotificationCenter.current().getNotificationSettings { settings in
        notificationsStatus = settings.authorizationStatus
    }
}

func sendMorningReminder() {
    sendEveningReminder()
    if !UserDefaults.standard.bool(forKey: "dailyNotifications") {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["MORNING"])
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ["MORNING"])
        return
    }
    var tomorrow = Date().dayAfter
    if Date().hour < 8 {
        tomorrow = Date()
    }
    let tomorrowTasks = fetchAllTasks().undoneTasksForTheDay(day: tomorrow)

    let content = UNMutableNotificationContent()
    content.title = "Good morning".localized
    if !tomorrowTasks.isEmpty {
        if tomorrowTasks.count == 1 {
            content.body = "You have 1 task for today 💪".localized
        } else {
            content.body = "You have %d tasks for today 💪".localized.format(tomorrowTasks.count)
        }
    } else {
        content.body = "You don't have any tasks for today. Lucky you 😉".localized
    }
    content.sound = .default
    if !UserDefaults.standard.bool(forKey: "badgeToday") {
        content.badge = 1
    }
    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["MORNING"])
    UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ["MORNING"])
    let targetDate = tomorrow.startOfDay.addingTimeInterval(TimeInterval(60 * 60 * 8))
    let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: targetDate), repeats: false)
    let request = UNNotificationRequest(identifier: "MORNING", content: content, trigger: trigger)
    UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
        if error != nil {
            print("Error with notifications")
        }
    })
}

func sendEveningReminder() { // TODO: if delets -> still count
    if !UserDefaults.standard.bool(forKey: "dailyNotifications") {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["EVENING"])
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ["EVENING"])
        return
    }
    if Date().hour >= 21 {
        return
    }
    let today = Date()
    let todayTasks = fetchAllTasks().doneTasksForTheDay(day: today)

    let content = UNMutableNotificationContent()
    content.title = "Good evening".localized
    if !todayTasks.isEmpty {
        if todayTasks.count == 1 {
            content.body = "You have completed 1 task today. Good job 👍".localized
        } else {
            content.body = "You have completed %d tasks today. Good job 👍".localized.format(todayTasks.count)
        }
    } else {
        content.body = "Don't forget to mark your completed tasks for today 😉".localized
        return
    }
    content.sound = .default
    if !UserDefaults.standard.bool(forKey: "badgeToday") {
        content.badge = 1
    }
    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["EVENING"])
    UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ["EVENING"])
    let targetDate = today.startOfDay.addingTimeInterval(TimeInterval(60 * 60 * 21))
    let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: targetDate), repeats: false)
    let request = UNNotificationRequest(identifier: "EVENING", content: content, trigger: trigger)
    UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
        if error != nil {
            print("Error with notifications")
        }
    })
}
