//
//  TaskManager.swift
//  EisenhowerToDo
//
//  Created by Maple Ong on 5/30/18.
//  Copyright © 2018 MO. All rights reserved.
//

import UIKit
import CoreData

final class TaskManager {
        
    static func willSave() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    static func save(name: String, done: Bool, urgency: Bool, importantness: Bool) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Task", in: managedContext)!
        let newTask = NSManagedObject(entity: entity, insertInto: managedContext)
        
        newTask.setValue(name, forKeyPath: "name")
        newTask.setValue(done, forKeyPath: "done")
        newTask.setValue(urgency, forKeyPath: "urgency")
        newTask.setValue(importantness, forKeyPath: "importantness")

        willSave()
    }
    
    static func fetch(done: Bool, urgency: Bool? = nil, importantness: Bool? = nil, name: String? = nil) -> [NSManagedObject] {
        var tasks = [NSManagedObject]()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return tasks
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Task")
        
        let donePredicate = NSPredicate(format: "done == %@", NSNumber(value: done))
        var allSubPredicates = [donePredicate]
        
        if let urgency = urgency {
            let urgencyPredicate = NSPredicate(format: "urgency == %@", NSNumber(value: urgency))
            allSubPredicates.append(urgencyPredicate)
        }
        
        if let importantness = importantness {
            let importantnessPredicate = NSPredicate(format: "importantness == %@", NSNumber(value: importantness))
            allSubPredicates.append(importantnessPredicate)
        }
        
        if let name = name {
            let namePredicate = NSPredicate(format: "name == %@", name)
            allSubPredicates.append(namePredicate)
        }
        
        let andPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: allSubPredicates)
        fetchRequest.predicate = andPredicate
        
        do {
            tasks = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        willSave()
        return tasks
    }
    
    static func delete(task: NSManagedObject) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        guard let done = task.value(forKey: "done") as? Bool,
            let urgency = task.value(forKey: "urgency") as? Bool,
            let importantness = task.value(forKey: "importantness") as? Bool,
            let name = task.value(forKey: "name") as? String else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Task")
        let andPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and,
                                               subpredicates: [NSPredicate(format: "done == %@", NSNumber(value: done)),
                                                               NSPredicate(format: "urgency == %@", NSNumber(value: urgency)),
                                                               NSPredicate(format: "importantness == %@", NSNumber(value: importantness)),
                                                               NSPredicate(format: "name == %@", name) ])
        fetchRequest.predicate = andPredicate
        fetchRequest.fetchLimit = 1
        
        do {
            let fetchedResults =  try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let fetchedResults = fetchedResults, fetchedResults.count == 1 {
                managedContext.delete(fetchedResults[0])
            }
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
        
        willSave()
    }
    
    static func toggleDone(task: NSManagedObject) {
        if let currentStatus = task.value(forKey: "done") as? Bool, currentStatus {
            task.setValue(false, forKey: "done")
        } else {
            task.setValue(true, forKey: "done")
        }
        
        willSave()
    }
}
