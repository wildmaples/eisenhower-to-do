//
//  TaskCellTableViewCell.swift
//  EisenhowerToDo
//
//  Created by Maple Ong on 6/6/18.
//  Copyright © 2018 MO. All rights reserved.
//

import UIKit
import CoreData

// Protocol for delegation
protocol TaskCellDelegate: class {
    func removeTask(task: Task)
    func toggleDone(task: Task)
}

class TaskCellTableViewCell: UITableViewCell {

    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var urgentLabel: UILabel!
    @IBOutlet weak var importantLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    weak var delegate: TaskCellDelegate?
    var task : Task!
    var isTaskDone: Bool = false
    
    override func awakeFromNib() {
        // Radio button setup
        doneButton.setImage(UIImage(named: "uncheckButton"), for: .normal)
        doneButton.setImage(UIImage(named: "checkButton"), for: .selected)
        
        // Label box styling
        importantLabel.layer.borderColor = UIColor.black.cgColor
        importantLabel.layer.borderWidth = 1.0
        urgentLabel.layer.borderColor = UIColor.black.cgColor
        urgentLabel.layer.borderWidth = 1.0
        
        taskLabel.sizeToFit()
    }
    
    func setup() {
        taskLabel.text = task.name
        isTaskDone = task.done
        doneButton.isSelected = task.done
        
        labelsSetUp()
    }
    
    private func labelsSetUp() {
        if task.importantness && task.urgency {
            importantLabel.text = "Important"
            importantLabel.isHidden = false
            urgentLabel.isHidden = false
        } else if !task.importantness && task.urgency {
            importantLabel.text = "Urgent"
            importantLabel.isHidden = false
            urgentLabel.isHidden = true
        } else if task.importantness && !task.urgency {
            importantLabel.text = "Important"
            importantLabel.isHidden = false
            urgentLabel.isHidden = true
        } else if !task.importantness && !task.urgency {
            urgentLabel.isHidden = true
            importantLabel.isHidden = true
        }
    }
    
    @IBAction func doneButton(_ sender: Any) {
        self.delegate?.toggleDone(task: task)
    }
    
    @IBAction func deleteButton(_ sender: Any) {
        self.delegate?.removeTask(task: task)
    }
}
