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
    @IBOutlet weak var doneButton: UIButton!
    
    weak var delegate: TaskCellDelegate?
    var task : Task!
    
    override func awakeFromNib() {
        // Radio button setup
        doneButton.setImage(UIImage(named: "uncheckButton"), for: .normal)
        doneButton.setImage(UIImage(named: "checkButton"), for: .selected)
        
        // Label box styling
        importantLabel.layer.borderColor = UIColor.black.cgColor
        importantLabel.layer.borderWidth = 1.0
        urgentLabel.layer.borderColor = UIColor.black.cgColor
        urgentLabel.layer.borderWidth = 1.0
    }
    
    func setup(task: Task) {
        
        self.task = task
        taskLabel.text = task.name
        doneButton.isSelected = task.done
        if task.importantness == true && task.urgency == true {
            importantLabel.isHidden = false
            urgentLabel.isHidden = false
        } else if task.importantness == false && task.urgency == true {
            importantLabel.text = "Urgent"
            urgentLabel.isHidden = true
        } else if task.importantness == true && task.urgency == false {
            importantLabel.isHidden = false
            urgentLabel.isHidden = true
        } else if task.importantness == false && task.urgency == false {
            urgentLabel.isHidden = true
            importantLabel.isHidden = true
        }
    }
    
    @IBAction func doneButton(_ sender: Any) {
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
