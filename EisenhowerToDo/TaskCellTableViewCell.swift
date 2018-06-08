//
//  TaskCellTableViewCell.swift
//  EisenhowerToDo
//
//  Created by Maple Ong on 6/6/18.
//  Copyright © 2018 MO. All rights reserved.
//

import UIKit

class TaskCellTableViewCell: UITableViewCell {

    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var doneButton: UISwitch!
    @IBOutlet weak var urgentLabel: UILabel!
    @IBOutlet weak var importantLabel: UILabel!
    
    weak var delegate: UpdateDelegate?
    var task : Task!
    var index : Int!
    
     func viewDidLoad() {
        _ = UITableViewCell()
        self.backgroundColor = .blue

    }
    func setup(task: Task) {
        
        // base edit
        taskLabel.text = task.name
        doneButton.isOn = task.done

        if task.importantness == true && task.urgency == true {
            // insert other styling edits here
            
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
    
    @IBAction func doneToggle(_ sender: Any) {
        if self.task.done == true {
            
            // make the task undone
            task.done = false
            self.delegate?.categorizeTask(task: task)
            self.delegate?.mark(task: task, asDone: task.done)
            self.delegate?.didUpdate(sender: self)
            
        } else {
            
            // this only happens in the completed task tableView
            task.done = true
            let indexPath = IndexPath(row: index, section:0)
            self.delegate?.removeTask(sender: self, task: task, row: indexPath as IndexPath)
            self.delegate?.mark(task: task, asDone: task.done)
            self.delegate?.didUpdate(sender: self)

        }
        print("\(task.done)")

    }
    
    
    @IBAction func deleteButton(_ sender: Any) {
        let indexPath = IndexPath(row: index, section:0)
        self.delegate?.removeTask(sender: self, task: task, row: indexPath as IndexPath)
    }
    

    
}