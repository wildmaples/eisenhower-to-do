//
//  ModifyTaskViewController.swift
//  EisenhowerToDo
//
//  Created by Maple Ong on 6/7/18.
//  Copyright © 2018 MO. All rights reserved.
//

import UIKit

protocol ModifyTaskDelegate: class {
    func removeTask(task: Task)
    func categorizeTask(task: Task)
}

class ModifyTaskViewController: UIViewController {
    
    var task: Task!
    var modTask: Task!
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var urgentSwitch: UISwitch!
    @IBOutlet weak var importantSwitch: UISwitch!
    weak var delegate: ModifyTaskDelegate?

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
