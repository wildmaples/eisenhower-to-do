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
    @IBOutlet weak var urgentLabel: UILabel!
    @IBOutlet weak var importantLabel: UILabel!
    @IBOutlet weak var radioButton: UIButton!

    weak var delegate: UpdateDelegate?
    var task : Task!
    var index : Int!
    
    func viewDidLoad() {
        let radioButton = UIButton(type: .custom)
        radioButton.isSelected = true
    }
    
    func setup(task: Task) {
        self.task = task
        // base edit
        radioButton.setImage(UIImage(named: "uncheckButton"), for: .normal)
        radioButton.setImage(UIImage(named: "checkButton"), for: .selected)
        taskLabel.text = task.name
        radioButton.isSelected = task.done
        
        // label boxing style
        importantLabel.layer.borderColor = UIColor.black.cgColor
        importantLabel.layer.borderWidth = 1.0
        urgentLabel.layer.borderColor = UIColor.black.cgColor
        urgentLabel.layer.borderWidth = 1.0

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
    

    @IBAction func radioButton(_ sender: Any) {
        
        // if task is done
        if self.task.done == true {
            
            // make it not done
            radioButton.isSelected = false
            task.done = false
            // push task back into 1/4 tableviews
            self.delegate?.categorizeTask(task: task)
            // remove task from done list
            self.delegate?.mark(task: task, asDone: task.done)
            // refresh
            self.delegate?.didUpdate(sender: self)
            
        // if task is not done
        } else {
            
            // make task done
            radioButton.isSelected = true
            task.done = true
            
            let indexPath = IndexPath(row: index, section:0)
            
            // remove task from respective list 
            self.delegate?.removeTask(sender: self, task: task, row: indexPath as IndexPath)
            self.delegate?.mark(task: task, asDone: task.done)
            self.delegate?.didUpdate(sender: self)
        }
        print("\(task.done)")
    }
        
    
    @IBAction func deleteButton(_ sender: Any) {
        let indexPath = IndexPath(row: index, section:0)
        
        // if task is from the completed list
        if task.done == true {
            task.done = false
            self.delegate?.removeTask(sender: self, task: task, row: indexPath as IndexPath)
            
        // if task is anywhere else
        } else {
        self.delegate?.removeTask(sender: self, task: task, row: indexPath as IndexPath)
        }
    }
}
