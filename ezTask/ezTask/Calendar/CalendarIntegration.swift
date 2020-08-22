//
//  CalendarIntegration.swift
//  ezTask
//
//  Created by Mike Ovyan on 22.08.2020.
//  Copyright © 2020 Mike Ovyan. All rights reserved.
//

import CoreData
import EventKit
import Foundation
import UIKit

func requestCalendarAccess() {
    let eventStore = EKEventStore()

    switch EKEventStore.authorizationStatus(for: .event) {
    case .authorized:
        print("Authorized")

    case .denied:
        print("Access denied")

    case .notDetermined:
        eventStore.requestAccess(to: .event, completion:
            { (granted: Bool, _: Error?) -> Void in
                if granted {
                    print("Access granted")
                } else {
                    print("Access denied")
                }
        })

        print("Not Determined")
    default:
        print("Case Default")
    }
}

func getCalendars() -> [EKCalendar] {
    let eventStore = EKEventStore()
    let calendars = eventStore.calendars(for: .event)

    return calendars
}

func getColorOfCalendar(calendarTitle: String) -> UIColor {
    for calendar in getCalendars() {
        if calendar.title == calendarTitle {
            return UIColor(cgColor: calendar.cgColor)
        }
    }

    return UIColor.systemGray
}

public func loadAllChosenCalendars() {
    if !UserDefaults.standard.bool(forKey: "importCalendars") {
        return
    }
    if UserDefaults.standard.stringArray(forKey: "chosenCalendars") != nil {
        let chosenCalendars = UserDefaults.standard.stringArray(forKey: "chosenCalendars")!
        for calendar in chosenCalendars {
            loadCalendar(calendarTitle: calendar)
        }
    }
}

public func removeAllCalendars() {
    for calendar in getCalendars() {
        removeCalendar(calendarTitle: calendar.title)
    }
}

public func loadCalendar(calendarTitle: String) {
    if !UserDefaults.standard.bool(forKey: "importCalendars") {
        return
    }
    getUsedEventIds(calendarTitle: calendarTitle)
}

func removeCalendar(calendarTitle: String) {
    deleteTasksFromCalendar(calendarTitle: calendarTitle, completion: {})
}

public func getUsedEventIds(calendarTitle: String) {
    var usedEventIds: [String] = []
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return
    }
    let managedContext = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<TaskCoreModel>(entityName: "TaskCoreModel")
    fetchRequest.predicate = NSPredicate(format: "calendarTitle = %@", calendarTitle)
    do {
        let res = try managedContext.fetch(fetchRequest)
        if !res.isEmpty {
            for r in res {
                usedEventIds.append(r.eventId!)
            }
        }
        addTasksFromCalender(calendarTitle: calendarTitle, usedEventIds: usedEventIds)
    } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
    }
}

func addTasksFromCalender(calendarTitle: String, usedEventIds: [String]) {
    let eventStore = EKEventStore()
    let calendars = eventStore.calendars(for: .event)
    for calendar in calendars {
        if calendar.title == calendarTitle {
            let predicate = eventStore.predicateForEvents(withStart: Date().startOfDay, end: Date().addDays(add: 40), calendars: [calendar])
            let events = eventStore.events(matching: predicate)
            for event in events {
                if usedEventIds.contains(event.eventIdentifier) {
                    continue
                }
                let task = TaskModel(id: UUID(), mainText: event.title, subtasks: nil, isPriority: false, isDone: false, taskDate: event.startDate, isAlarmSet: !event.isAllDay, alarmDate: event.isAllDay ? nil : event.startDate, dateCompleted: nil, dateModified: Date(), reccuringDays: nil, calendarTitle: event.calendar.title, eventId: event.eventIdentifier)
                save(model: task, completion: {})
            }
            break
        }
    }
}

public func deleteTasksFromCalendar(calendarTitle: String, completion: () -> Void) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return
    }
    let managedContext = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<TaskCoreModel>(entityName: "TaskCoreModel")
    fetchRequest.predicate = NSPredicate(format: "calendarTitle = %@", calendarTitle)
    do {
        let res = try managedContext.fetch(fetchRequest)
        if !res.isEmpty {
            for r in res {
                removeNotificationsById(id: r.id!.uuidString)
                managedContext.delete(r)
            }
        }
    } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
    }
    do {
        try managedContext.save()
        completion()
        sendMorningReminder()
    } catch {
        print("Failed to save updated")
    }
}
