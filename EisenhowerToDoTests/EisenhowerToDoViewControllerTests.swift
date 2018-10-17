//
//  EisenhowerToDoViewControllerTests.swift
//  EisenhowerToDoTests
//
//  Created by maple peijune on 2018-10-16.
//  Copyright © 2018 MO. All rights reserved.
//

import CoreData
import XCTest
@testable import EisenhowerToDo

class EisenhowerToDoViewControllerTests: XCTestCase {

    var sut: ViewController!
    var mockPersistantContainer: NSPersistentContainer!
    var mockTaskManager: TaskManager!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = (storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController)
        _ = sut.view // To call viewDidLoad
        mockTaskManager = sut.taskManager
        mockPersistantContainer = sut.taskManager.persistentContainer
        initStubs()
    }
    
    override func tearDown() {
        deinitStubs()
        super.tearDown()
    }

    func initStubs() {
        func addTestTask(name: String, done: Bool, urgency: Bool, importantness: Bool) {
            let testTask = NSEntityDescription.insertNewObject(forEntityName: "Task", into: mockPersistantContainer.viewContext)
            
            testTask.setValue(name, forKey: "name")
            testTask.setValue(done, forKey: "done")
            testTask.setValue(urgency, forKey: "urgency")
            testTask.setValue(importantness, forKey: "importantness")
        }
        
        addTestTask(name: "1", done: false, urgency: true, importantness: true)
        addTestTask(name: "2", done: false, urgency: true, importantness: true)
        addTestTask(name: "3", done: false, urgency: true, importantness: true)
        addTestTask(name: "4", done: false, urgency: true, importantness: true)
        addTestTask(name: "5", done: false, urgency: true, importantness: true)

        do {
            try mockPersistantContainer.viewContext.save()
        }  catch {
            print("create fakes error \(error)")
        }
    }
    
    func deinitStubs() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        let testTasks = try! mockPersistantContainer.viewContext.fetch(fetchRequest)
        for case let testTask as NSManagedObject in testTasks {
            mockPersistantContainer.viewContext.delete(testTask)
        }
        try! mockPersistantContainer.viewContext.save()
    }

    func testTaskCreation() {
        let name = "A FAKE TO DO THAT IS IMPORTANT AND URGENT"
        mockTaskManager.save(name: name, done: false, urgency: true, importantness: true)
        sut.fetchFromCoreData()
    
        XCTAssertNotNil(sut.importantUrgentList)
        XCTAssertEqual(sut.importantUrgentList.count, 5+1) // 5 stubs + 1 created
        deinitStubs()
    }
    
    func testToggleDone() {
        let testTask = NSEntityDescription.insertNewObject(forEntityName: "Task", into: mockPersistantContainer.viewContext)
        
        testTask.setValue("TESTTOGGLEDONE", forKey: "name")
        testTask.setValue(false, forKey: "done")
        testTask.setValue(true, forKey: "urgency")
        testTask.setValue(true, forKey: "importantness")

        sut.toggleDone(task: testTask as! Task)

        XCTAssertEqual(sut.allDoneTasks.count, 1) // After toggled, there will be one done task
        deinitStubs()
    }

    func testRemoveTasks() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        fetchRequest.predicate = NSPredicate(format: "name == %@", "1")
        fetchRequest.fetchLimit = 1
        let fetchedTask = try! mockPersistantContainer.viewContext.fetch(fetchRequest)
        for task in fetchedTask{
            sut.removeTask(task: task as! Task)
        }
        XCTAssertEqual(sut.importantUrgentList.count, 4)
        deinitStubs()
    }
}
