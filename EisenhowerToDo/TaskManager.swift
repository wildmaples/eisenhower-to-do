//
//  TaskManager.swift
//  EisenhowerToDo
//
//  Created by Maple Ong on 5/30/18.
//  Copyright © 2018 MO. All rights reserved.
//

import UIKit
import CoreData

class TaskManager {
    
    var persistentContainer: NSPersistentContainer!
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
    func saveContext() {
        let managedContext = persistentContainer.viewContext
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func save(name: String, done: Bool, urgency: Bool, importantness: Bool) {
        let managedContext = persistentContainer.viewContext
        let newTask = NSEntityDescription.insertNewObject(forEntityName: "Task", into: managedContext) as! Task
        
        newTask.name = name
        newTask.done = done
        newTask.urgency = urgency
        newTask.importantness = importantness

        saveContext()
    }
    
    func fetch(done: Bool, urgency: Bool? = nil, importantness: Bool? = nil, name: String? = nil) -> [Task] {
        var tasks = [Task]()

        let managedContext = persistentContainer.viewContext
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
            tasks = try managedContext.fetch(fetchRequest) as! [Task]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return tasks
    }
    
    func delete(task: Task) {
        task.managedObjectContext?.delete(task)
        saveContext()
    }
    
    func toggleDone(task: Task) {
        if task.done {
            task.done = false
        } else {
            task.done = true
        }

        saveContext()
    }
}
