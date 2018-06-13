//
//  ModifyTaskViewController.swift
//  EisenhowerToDo
//
//  Created by Maple Ong on 6/7/18.
//  Copyright © 2018 MO. All rights reserved.
//

import UIKit

class ModifyTaskViewController: UIViewController {
    
    var task: Task!
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var urgentSwitch: UISwitch!
    @IBOutlet weak var importantSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = task.name
        urgentSwitch.isOn = task.urgency
        importantSwitch.isOn = task.importantness
    }
    
    
    // Cancel Action
    @IBAction func cancelToWorkoutViewController(_ segue: UIStoryboardSegue) {
        self.dismiss(animated: true, completion: nil)
    }

    
}
