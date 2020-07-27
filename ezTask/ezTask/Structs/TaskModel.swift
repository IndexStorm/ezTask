//
//  TaskModel.swift
//  ezTask
//
//  Created by Mike Ovyan on 27.07.2020.
//  Copyright © 2020 Mike Ovyan. All rights reserved.
//

import Foundation
import CoreData

public struct TaskModel {
    let id: UUID
    let mainText: String
    let isPriority: Bool
    let isDone: Bool
    let taskDate: Date
    let isAlarmSet: Bool
    let alarmDate: Date?

    init(task: NSManagedObject) {
        self.id = task.value(forKey: "id") as! UUID
        self.mainText = task.value(forKey: "mainText") as! String
        self.isPriority = task.value(forKey: "isPriority") as! Bool
        self.isDone = task.value(forKey: "isDone") as! Bool
        self.taskDate = task.value(forKey: "taskDate") as! Date
        self.isAlarmSet = task.value(forKey: "isAlarmSet") as! Bool
        self.alarmDate = task.value(forKey: "alarmDate") as? Date
    }

    init(id: UUID, mainText: String, isPriority: Bool, isDone: Bool, taskDate: Date, isAlarmSet: Bool, alarmDate: Date?) {
        self.id = id
        self.mainText = mainText
        self.isPriority = isPriority
        self.isDone = isDone
        self.taskDate = taskDate
        self.isAlarmSet = isAlarmSet
        self.alarmDate = alarmDate
    }
}
