//
//  FTTableViewCell.swift
//  EisenhowerToDo
//
//  Created by Maple Ong on 5/30/18.
//  Copyright © 2018 MO. All rights reserved.
//

import UIKit

class NImportantUrgentTableViewCell: UITableViewCell {

    @IBOutlet weak var FTTaskLabel: UILabel!
    @IBOutlet weak var doneButton: UISwitch!
    weak var delegate: UpdateDelegate?
    var task : Task!

    func setup(task: Task) {
        FTTaskLabel.text = task.name
        doneButton.isOn = task.done
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
    


}
