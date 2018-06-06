//
//  TTTableViewCell.swift
//  EisenhowerToDo
//
//  Created by Maple Ong on 5/30/18.
//  Copyright © 2018 MO. All rights reserved.
//

import UIKit

class ImportantUrgentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var doneButton: UISwitch!
    weak var delegate: UpdateDelegate?
    var task : Task!
    var index : Int!

    func setup(task: Task)  {
        taskLabel.text = task.name
        doneButton.isOn = task.done
        print ("Tasklabel :\(taskLabel.text ?? "asds")")
    }
    
    @IBAction func doneToggle(_ sender: Any) {
        if self.task.done == true {
            task.done = false
        }
        else {
            task.done = true
        }
        print("\(task.done)")
    }
    
    @IBAction func refreshTV(_ sender: Any) {
        self.delegate?.didUpdate(sender: self)
    }
    
    @IBAction func deleteButton(_ sender: Any) {
        let indexPath = IndexPath(row: index, section:0)
        self.delegate?.removeTask(sender: self, task: task, row: indexPath as IndexPath)
    }
}
