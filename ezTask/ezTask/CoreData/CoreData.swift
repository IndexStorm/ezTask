//
//  CoreData.swift
//  ezTask
//
//  Created by Mike Ovyan on 27.07.2020.
//  Copyright © 2020 Mike Ovyan. All rights reserved.
//

import Foundation
import UIKit
import CoreData

public func save(model: TaskModel, completion: () -> (Void)) {
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
    task.setValue(model.alarmDate, forKey: "alarmDate") // TODO: check if nil value saves correctly
    do {
        try managedContext.save()
//        if !model.isDone {
//            undoneTasks.append(task)
//        }
        completion()
    } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
    }
}

public func setDone(id: String) {
    // removing alarms
    removeNotificationsById(id: id)
    // TODO: remove alarm from DB
    
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
        }
    } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
    }
    do {
        try managedContext.save()
    } catch {
        print("Failed to save updated")
    }
}
