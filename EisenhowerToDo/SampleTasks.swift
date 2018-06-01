//
//  SampleTasks.swift
//  EisenhowerToDo
//
//  Created by Maple Ong on 5/30/18.
//  Copyright © 2018 MO. All rights reserved.
//

import Foundation


struct Task {
    
    // Properties
    var name: String
    var urgency: Bool = false
    var importantness: Bool = false
    var done: Bool = false
}


// Generating sample tasks to populate list
final class SampleData {
    static func generateTT() -> [Task] {
        return [
                Task(name: "Buy broccoli and tape", urgency: true, importantness: true, done: false),
                Task(name: "Be a vegan", urgency: true, importantness: true, done: false),
                Task(name: "Watch Deadpool 2", urgency: true, importantness: true, done: false)
        ]
    }
    
    static func generateFT() -> [Task] {
        return [
                Task(name: "Reply Emails", urgency: true, importantness: false, done: false),
                Task(name: "Run errand to update address on drivers Li", urgency: true, importantness: false, done: false),
                Task(name: "Something not important but urgent", urgency: true, importantness: false, done: false)
        ]

    }
    
    // To-Do: Add the other two lists
}


