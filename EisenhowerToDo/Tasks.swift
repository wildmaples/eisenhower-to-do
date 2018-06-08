//
//  SampleTasks.swift
//  EisenhowerToDo
//
//  Created by Maple Ong on 5/30/18.
//  Copyright © 2018 MO. All rights reserved.
//

import Foundation


final class Task {
    // Properties
    var name: String
    var importantness: Bool
    var urgency: Bool
    var done: Bool
    
    init(){
        self.name = ""
        self.urgency = false
        self.importantness = false
        self.done = false
    }
}


// Generating sample tasks to populate list
final class SampleData {
    static func generateTT() -> [Task] {
        let TT1 = Task()
        TT1.urgency = true
        TT1.importantness = true
        TT1.name = "Buy broccoli and tape"
        TT1.done = true
        
        let TT2 = Task()
        TT2.urgency = true
        TT2.importantness = true
        TT2.name = "Be a vegan"
        TT2.done = false

        
        let TT3 = Task()
        TT3.urgency = true
        TT3.importantness = true
        TT3.name = "Watch Deadpool 2"
        TT3.done = false

        
        return [TT2, TT3]
    }
    
    static func generateFT() -> [Task] {
        let FT1 = Task()
        FT1.urgency = true
        FT1.importantness = false
        FT1.name = "Reply Emails"
        FT1.done = false

        
        let FT2 = Task()
        FT2.urgency = true
        FT2.importantness = false
        FT2.name = "Run errand to update address on drivers Li"
        FT2.done = false

        
        let FT3 = Task()
        FT3.urgency = true
        FT3.importantness = false
        FT3.name = "Something not important but urgent"
        FT3.done = false

        return [FT1, FT2, FT3]
        
    }
    
    static func generateTF() -> [Task] {
        let TF1 = Task()
        TF1.urgency = false
        TF1.importantness = true
        TF1.name = "Call momma"
        
        let TF2 = Task()
        TF2.urgency = false
        TF2.importantness = true
        TF2.name = "Make an appointment for an annual checkup"
        
        let TF3 = Task()
        TF3.urgency = false
        TF3.importantness = true
        TF3.name = "Ask Fred about that one thing"
        
        return [TF1, TF2, TF3]
        
    }
    
    static func generateFF() -> [Task] {
        let FF1 = Task()
        FF1.urgency = false
        FF1.importantness = false
        FF1.name = "Watch Deadpool"
        
        let FF2 = Task()
        FF2.urgency = false
        FF2.importantness = false
        FF2.name = "Do something dumb "
        
        let FF3 = Task()
        FF3.urgency = false
        FF3.importantness = false
        FF3.name = "Ask Fred about that one thing"
        
        return [FF1, FF2, FF3]
    }
    static func generate_done() -> [Task] {
        let FF1 = Task()
        FF1.urgency = false
        FF1.importantness = false
        FF1.name = "Watch Deadpool"
        
        let FF2 = Task()
        FF2.urgency = false
        FF2.importantness = false
        FF2.name = "Do something dumb "
        
        let FF3 = Task()
        FF3.urgency = false
        FF3.importantness = false
        FF3.name = "Ask Fred about that one thing"
        
        return [FF1, FF2, FF3]
    }

}


