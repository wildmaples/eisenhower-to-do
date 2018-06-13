//
//  TaskCellTableViewCell.swift
//  EisenhowerToDo
//
//  Created by Maple Ong on 6/6/18.
//  Copyright © 2018 MO. All rights reserved.
//

import UIKit

// Protocol for delegation
protocol TaskCellDelegate: class {
    func removeTask(task: Task)
    func removeDoneTask(task: Task)
    func mark(task: Task)
    func categorizeTask(task: Task)
}

class TaskCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var doneButton: UISwitch!
    @IBOutlet weak var urgentLabel: UILabel!
    @IBOutlet weak var importantLabel: UILabel!
    
    weak var delegate: TaskCellDelegate?
    var task : Task!
    var index : Int!
    
    func setup(task: Task) {
        
        self.task = task
        taskLabel.text = task.name
        doneButton.isOn = task.done
        
        if task.importantness == true && task.urgency == true {
            // insert other styling edits here later
            
        } else if task.importantness == false && task.urgency == true {
            importantLabel.isHidden = true
        }
    }
    
    @IBAction func doneToggle(_ sender: Any) {
        
        // for tasks that are in completed list
        if self.task.done == true {
            self.delegate?.categorizeTask(task: task)
            self.delegate?.mark(task: task)
            self.delegate?.removeDoneTask(task: task)
            
        } else {
            self.delegate?.mark(task: task)
            self.delegate?.removeTask(task: task)
        }
        print("\(task.done)")
        
    }
    
    
    @IBAction func deleteButton(_ sender: Any) {
        self.delegate?.removeTask(task: task)

    }
    
}
