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
    //weak var delegate: UpdateDelegate?

    var task : Task!
    var toggledTask :Task!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
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
        toggledTask = task
        
//    }
//    
}


