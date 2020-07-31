//
//  CoreData.swift
//  ezTask
//
//  Created by Mike Ovyan on 27.07.2020.
//  Copyright © 2020 Mike Ovyan. All rights reserved.
//

import CoreData
import Foundation
import UIKit

public func save(model: TaskModel, completion: () -> Void) {
    guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else {
        return
    }
    let managedContext = appDelegate.persistentContainer.viewContext
    let entity = NSEntityDescription.entity(forEntityName: "TaskCoreModel", in: managedContext)!
    let task = NSManagedObject(entity: entity, insertInto: managedContext)
    task.setValue(model.id, forKey: "id")
    task.setValue(model.mainText, forKeyPath: "mainText")
    task.setValue(model.isDone, forKeyPath: "isDone")
    task.setValue(model.isPriority, forKey: "isPriority")
    task.setValue(model.taskDate, forKey: "taskDate")
    task.setValue(model.isAlarmSet, forKey: "isAlarmSet")
    task.setValue(model.alarmDate, forKey: "alarmDate")
    task.setValue(model.dateCompleted, forKey: "dateCompleted")
    task.setValue(model.dateModified, forKey: "dateModified")
    do {
        try managedContext.save()
        completion()
    } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
    }
}

public func setDone(id: String, completion: () -> Void) {
    // removing alarms
    removeNotificationsById(id: id)
    // TODO: keep alarmDate?
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return
    }
    let managedContext = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<TaskCoreModel>(entityName: "TaskCoreModel")
    fetchRequest.predicate = NSPredicate(format: "id = %@", id)
    do {
        let res = try managedContext.fetch(fetchRequest)
        if !res.isEmpty {
            res[0].setValue(true, forKey: "isDone")
            res[0].setValue(false, forKey: "isAlarmSet")
            res[0].setValue(nil, forKey: "alarmDate")
            res[0].setValue(Date(), forKey: "dateCompleted")
            res[0].setValue(Date(), forKey: "dateModified") // TODO: check if should change here
        }
    } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
    }
    do {
        try managedContext.save()
        completion()
    } catch {
        print("Failed to save updated")
    }
}

public func setUndone(id: String, completion: () -> Void) {
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
    } catch {
        print("Failed to save updated")
    }
}

public func deleteTask(id: String, completion: () -> Void) {
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
    } catch {
        print("Failed to save updated")
    }
}

public func update(id: String, newModel: TaskModel, completion: () -> Void) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return
    }
    let managedContext = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<TaskCoreModel>(entityName: "TaskCoreModel")
    fetchRequest.predicate = NSPredicate(format: "id = %@", id)
    do {
        let res = try managedContext.fetch(fetchRequest)
        if !res.isEmpty {
            res[0].setValue(newModel.mainText, forKey: "mainText")
            res[0].setValue(newModel.isDone, forKey: "isDone")
            res[0].setValue(newModel.isPriority, forKey: "isPriority")
            res[0].setValue(newModel.taskDate, forKey: "taskDate")
            res[0].setValue(newModel.isAlarmSet, forKey: "isAlarmSet")
            res[0].setValue(newModel.alarmDate, forKey: "alarmDate") // TODO: check if works if nil
            res[0].setValue(newModel.dateCompleted, forKey: "dateCompleted") // ^
            res[0].setValue(Date(), forKey: "dateModified")
        }
    } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
    }
    do {
        try managedContext.save()
        completion()
    } catch {
        print("Failed to save updated")
    }
}
