//
//  TaskModel.swift
//  ezTask
//
//  Created by Mike Ovyan on 27.07.2020.
//  Copyright © 2020 Mike Ovyan. All rights reserved.
//

import CoreData
import Foundation

public struct TaskModel: Equatable, Comparable {
    let id: UUID
    let mainText: String
    let subtasks: String?
    let isPriority: Bool
    let isDone: Bool
    let taskDate: Date
    let isAlarmSet: Bool
    let alarmDate: Date?
    let dateCompleted: Date?
    let dateModified: Date

    init(task: NSManagedObject) {
        self.id = task.value(forKey: "id") as! UUID
        self.mainText = task.value(forKey: "mainText") as! String
        self.subtasks = task.value(forKey: "subtasks") as? String
        self.isPriority = task.value(forKey: "isPriority") as! Bool
        self.isDone = task.value(forKey: "isDone") as! Bool
        self.taskDate = task.value(forKey: "taskDate") as! Date
        self.isAlarmSet = task.value(forKey: "isAlarmSet") as! Bool
        self.alarmDate = task.value(forKey: "alarmDate") as? Date
        self.dateCompleted = task.value(forKey: "dateCompleted") as? Date
        self.dateModified = task.value(forKey: "dateModified") as! Date
    }

    init(id: UUID, mainText: String, subtasks: String?, isPriority: Bool, isDone: Bool, taskDate: Date, isAlarmSet: Bool, alarmDate: Date?, dateCompleted: Date?, dateModified: Date) {
        self.id = id
        self.mainText = mainText
        self.subtasks = subtasks
        self.isPriority = isPriority
        self.isDone = isDone
        self.taskDate = taskDate
        self.isAlarmSet = isAlarmSet
        self.alarmDate = alarmDate
        self.dateCompleted = dateCompleted
        self.dateModified = dateModified
    }

    public static func == (lhs: TaskModel, rhs: TaskModel) -> Bool {
        return lhs.id == rhs.id && lhs.mainText == rhs.mainText && lhs.subtasks == rhs.subtasks && lhs.isDone == rhs.isDone && lhs.isPriority == rhs.isPriority && lhs.taskDate == rhs.taskDate && lhs.isAlarmSet == rhs.isAlarmSet && lhs.alarmDate == rhs.alarmDate && lhs.dateCompleted == rhs.dateCompleted
    }

    public static func < (lhs: TaskModel, rhs: TaskModel) -> Bool {
        if !lhs.isDone, !rhs.isDone {
            if lhs.isPriority == rhs.isPriority {
                if lhs.isAlarmSet == rhs.isAlarmSet {
                    if lhs.isAlarmSet == false {
                        if lhs.taskDate.startOfDay == rhs.taskDate.startOfDay {
                            return lhs.dateModified > rhs.dateModified
                        }
                        return lhs.taskDate.startOfDay > rhs.taskDate.startOfDay
                    }
                    return lhs.alarmDate! < rhs.alarmDate!
                }
                return lhs.isAlarmSet
            }
            return lhs.isPriority
        }
        if lhs.isDone == rhs.isDone {
            if lhs.isPriority == rhs.isPriority {
                return lhs.dateCompleted! > rhs.dateCompleted!
            }
            return lhs.isPriority
        }
        return !lhs.isDone
    }
}

extension Array where Element == TaskModel {
    public func numberOfUndoneTasks() -> Int {
        return self.filter { !$0.isDone }.count
    }

    public func firstIndexById(id: String) -> Int {
        return self.firstIndex(where: { $0.id.uuidString == id }) ?? 0
    }
}
