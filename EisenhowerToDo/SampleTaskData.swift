//
//  SampleTaskData.swift
//  EisenhowerToDo
//
//  Created by maple peijune on 2018-10-15.
//  Copyright © 2018 MO. All rights reserved.
//

import Foundation

// Generating sample tasks to populate list for testing purposes

final class SampleData {
    static func generateTT(taskManager: TaskManager) {
        taskManager.save(name: "Buy stuff", done: false, urgency: true, importantness: true)
        taskManager.save(name: "Be a vegan", done: false, urgency: true, importantness: true)
        taskManager.save(name: "Watch Deadpool 2", done: false, urgency: true, importantness: true)
    }
    
    static func generateFT(taskManager: TaskManager) {
        taskManager.save(name: "Reply Emails", done: false, urgency: true, importantness: false)
        taskManager.save(name: "Run errand to update address on drivers Li", done: false, urgency: true, importantness: false)
        taskManager.save(name: "Something not important but urgent", done: false, urgency: true, importantness: false)
    }
    
    static func generateTF(taskManager: TaskManager) {
        taskManager.save(name: "Important but not urgent", done: false, urgency: false, importantness: true)
        taskManager.save(name: "Important but not urgent", done: false, urgency: false, importantness: true)
        taskManager.save(name: "Important but not urgent", done: false, urgency: false, importantness: true)
    }
    
    static func generateFF(taskManager: TaskManager) {
        taskManager.save(name: "Not important not urgent", done: false, urgency: false, importantness: false)
        taskManager.save(name: "Not important not urgent", done: false, urgency: false, importantness: false)
        taskManager.save(name: "Not important not urgent", done: false, urgency: false, importantness: false)
    }
}


