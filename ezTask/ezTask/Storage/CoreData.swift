//
//  CoreData.swift
//  ezTask
//
//  Created by Mike Ovyan on 27.07.2020.
//  Copyright © 2020 Mike Ovyan. All rights reserved.
//

import Amplitude
import CoreData
import Foundation
import UIKit

public func save(model: TaskModel, completion: () -> Void) {
    Amplitude.instance()?.logEvent("saved_task")
    guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else {
        return
    }
    setupReminder(task: model)
    let managedContext = appDelegate.persistentContainer.viewContext
    let entity = NSEntityDescription.entity(forEntityName: "TaskCoreModel", in: managedContext)!
    let task = NSManagedObject(entity: entity, insertInto: managedContext)
    task.setValue(model.id, forKey: "id")
    task.setValue(model.mainText, forKeyPath: "mainText")
    task.setValue(model.subtasks, forKeyPath: "subtasks")
    task.setValue(model.isDone, forKeyPath: "isDone")
    task.setValue(model.isPriority, forKey: "isPriority")
    task.setValue(model.taskDate, forKey: "taskDate")
    task.setValue(model.isAlarmSet, forKey: "isAlarmSet")
    task.setValue(model.alarmDate, forKey: "alarmDate")
    task.setValue(model.dateCompleted, forKey: "dateCompleted")
    task.setValue(model.dateModified, forKey: "dateModified")
    task.setValue(model.reccuringDays, forKey: "reccuringDays")
    do {
        try managedContext.save()
        completion()
        sendMorningReminder()
    } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
    }
}

public func setDone(id: String, completion: (_ newId: String?) -> Void) {
    Amplitude.instance()?.logEvent("set_done_task")
    removeNotificationsById(id: id)
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return
    }
    var newReccuringId: String?
    let managedContext = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<TaskCoreModel>(entityName: "TaskCoreModel")
    fetchRequest.predicate = NSPredicate(format: "id = %@", id)
    do {
        let res = try managedContext.fetch(fetchRequest)
        if !res.isEmpty {
            if res[0].value(forKey: "reccuringDays") != nil {
                newReccuringId = repeatReccuringTask(task: TaskModel(task: res[0]))
            }
            res[0].setValue(true, forKey: "isDone")
            res[0].setValue(false, forKey: "isAlarmSet")
            res[0].setValue(nil, forKey: "alarmDate")
            res[0].setValue(Date(), forKey: "dateCompleted")
            res[0].setValue(Date(), forKey: "dateModified")
            res[0].setValue(nil, forKey: "reccuringDays")
        }
    } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
    }
    do {
        try managedContext.save()
        completion(newReccuringId)
        sendMorningReminder()
    } catch {
        print("Failed to save updated")
    }
}

public func setUndone(id: String, completion: () -> Void) {
    Amplitude.instance()?.logEvent("set_undone_task")
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return
    }
    let managedContext = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<TaskCoreModel>(entityName: "TaskCoreModel")
    fetchRequest.predicate = NSPredicate(format: "id = %@", id)
    do {
        let res = try managedContext.fetch(fetchRequest)
        if !res.isEmpty {
            res[0].setValue(false, forKey: "isDone")
            res[0].setValue(nil, forKey: "dateCompleted")
            res[0].setValue(Date(), forKey: "dateModified")
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

public func deleteTask(id: String, completion: () -> Void) {
    Amplitude.instance()?.logEvent("deleted_task")
    removeNotificationsById(id: id)
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return
    }
    let managedContext = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<TaskCoreModel>(entityName: "TaskCoreModel")
    fetchRequest.predicate = NSPredicate(format: "id = %@", id)
    do {
        let res = try managedContext.fetch(fetchRequest)
        if !res.isEmpty {
            managedContext.delete(res[0])
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

public func update(id: String, newModel: TaskModel, completion: () -> Void) {
    Amplitude.instance()?.logEvent("updated_task")
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return
    }
    setupReminder(task: newModel)
    let managedContext = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<TaskCoreModel>(entityName: "TaskCoreModel")
    fetchRequest.predicate = NSPredicate(format: "id = %@", id)
    do {
        let res = try managedContext.fetch(fetchRequest)
        if !res.isEmpty {
            res[0].setValue(newModel.mainText, forKey: "mainText")
            res[0].setValue(newModel.subtasks, forKey: "subtasks")
            res[0].setValue(newModel.isDone, forKey: "isDone")
            res[0].setValue(newModel.isPriority, forKey: "isPriority")
            res[0].setValue(newModel.taskDate, forKey: "taskDate")
            res[0].setValue(newModel.isAlarmSet, forKey: "isAlarmSet")
            res[0].setValue(newModel.alarmDate, forKey: "alarmDate")
            res[0].setValue(newModel.dateCompleted, forKey: "dateCompleted")
            res[0].setValue(Date(), forKey: "dateModified")
            res[0].setValue(newModel.reccuringDays, forKey: "reccuringDays")
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

func fetchAllTasks() -> [TaskModel] {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return []
    }
    let managedContext = appDelegate.persistentContainer.viewContext
    let fetchAll = NSFetchRequest<TaskCoreModel>(entityName: "TaskCoreModel")
    do {
        let objects = try managedContext.fetch(fetchAll)
        return objects.map { TaskModel(task: $0) }
    } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
    }
    return []
}

func repeatReccuringTask(task: TaskModel) -> String {
    let newAlarmDate = task.isAlarmSet ? task.alarmDate!.addDays(add: task.reccuringDays!) : nil
    let newId = UUID()
    let newTask = TaskModel(id: newId, mainText: task.mainText, subtasks: task.subtasks, isPriority: task.isPriority, isDone: false, taskDate: task.taskDate.addDays(add: task.reccuringDays!), isAlarmSet: task.isAlarmSet, alarmDate: newAlarmDate, dateCompleted: nil, dateModified: Date(), reccuringDays: task.reccuringDays)
    save(model: newTask, completion: {})
    return newId.uuidString
}
