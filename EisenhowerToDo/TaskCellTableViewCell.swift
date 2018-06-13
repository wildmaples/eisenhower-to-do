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
    @IBOutlet weak var urgentLabel: UILabel!
    @IBOutlet weak var importantLabel: UILabel!
    @IBOutlet weak var radioButton: UIButton!
    
    weak var delegate: TaskCellDelegate?
    var task : Task!
    
    func viewDidLoad() {
        let radioButton = UIButton(type: .custom)
        radioButton.isSelected = true
    }
    
    func setup(task: Task) {
        
        self.task = task
        
        // Radio button setup
        radioButton.setImage(UIImage(named: "uncheckButton"), for: .normal)
        radioButton.setImage(UIImage(named: "checkButton"), for: .selected)
        taskLabel.text = task.name
        radioButton.isSelected = task.done
        
        // Label box styling
        importantLabel.layer.borderColor = UIColor.black.cgColor
        importantLabel.layer.borderWidth = 1.0
        urgentLabel.layer.borderColor = UIColor.black.cgColor
        urgentLabel.layer.borderWidth = 1.0
        
        if task.importantness == true && task.urgency == true {
            // insert other potential styling edits here
        } else if task.importantness == false && task.urgency == true {
            importantLabel.text = "Urgent"
            urgentLabel.isHidden = true
        } else if task.importantness == true && task.urgency == false {
            urgentLabel.isHidden = true
        } else if task.importantness == false && task.urgency == false {
            urgentLabel.isHidden = true
            importantLabel.isHidden = true
        }
    }
    
    
    @IBAction func radioButton(_ sender: Any) {
        if self.task.done == true {
            self.delegate?.categorizeTask(task: task)
            self.delegate?.mark(task: task)
            self.delegate?.removeDoneTask(task: task)
            
        } else {
            self.delegate?.mark(task: task)
            self.delegate?.removeTask(task: task)
        }
    }
    
    
    @IBAction func deleteButton(_ sender: Any) {
        self.delegate?.removeTask(task: task)
        // temp: just to make deleting a donetask work this PR
        self.delegate?.removeDoneTask(task: task)
    }
}
