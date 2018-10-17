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
    static func generateTT() {
        TaskManager.save(name: "Buy stuff", done: false, urgency: true, importantness: true)
        TaskManager.save(name: "Be a vegan", done: false, urgency: true, importantness: true)
        TaskManager.save(name: "Watch Deadpool 2", done: false, urgency: true, importantness: true)
    }
    
    static func generateFT() {
        TaskManager.save(name: "Reply Emails", done: false, urgency: true, importantness: false)
        TaskManager.save(name: "Run errand to update address on drivers Li", done: false, urgency: true, importantness: false)
        TaskManager.save(name: "Something not important but urgent", done: false, urgency: true, importantness: false)
    }
    
    static func generateTF() {
        TaskManager.save(name: "Important but not urgent", done: false, urgency: false, importantness: true)
        TaskManager.save(name: "Important but not urgent", done: false, urgency: false, importantness: true)
        TaskManager.save(name: "Important but not urgent", done: false, urgency: false, importantness: true)
    }
    
    static func generateFF() {
        TaskManager.save(name: "Not important not urgent", done: false, urgency: false, importantness: false)
        TaskManager.save(name: "Not important not urgent", done: false, urgency: false, importantness: false)
        TaskManager.save(name: "Not important not urgent", done: false, urgency: false, importantness: false)
    }
}


