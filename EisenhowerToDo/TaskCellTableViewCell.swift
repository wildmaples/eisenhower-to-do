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
    
    func setup(task: Task) {
        // base edit
        taskLabel.text = task.name
        doneButton.isOn = task.done

        if task.importantness == true && task.urgency == true {
            // insert other styling edits here
            
        } else if task.importantness == false && task.urgency == true {
            importantLabel.isHidden = true
        }
    }
    
    @IBAction func doneToggle(_ sender: Any) {
        if self.task.done == true {
            task.done = false
        }
        else {
            task.done = true
        }
        print("\(task.done)")
        self.delegate?.didUpdate(sender: self)
        
        if self.task.done {
        let indexPath = IndexPath(row: index, section:0)
        self.delegate?.removeTask(sender: self, task: task, row: indexPath as IndexPath)
        }

    }
    
    
    @IBAction func deleteButton(_ sender: Any) {
        let indexPath = IndexPath(row: index, section:0)
        self.delegate?.removeTask(sender: self, task: task, row: indexPath as IndexPath)
    }
    

    
}
