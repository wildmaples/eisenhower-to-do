//
//  ModifyTaskViewController.swift
//  EisenhowerToDo
//
//  Created by Maple Ong on 6/7/18.
//  Copyright © 2018 MO. All rights reserved.
//

import UIKit
import CoreData

class ModifyTaskViewController: UIViewController, UITextFieldDelegate {
    
    var task: NSManagedObject!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var urgentSwitch: UISwitch!
    @IBOutlet weak var importantSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameTextField.delegate = self
        setUp(task: task)
    }
    
    private func setUp(task: NSManagedObject) {
        self.task = task
        guard let name = task.value(forKeyPath: "name") as? String,
            let importantness = task.value(forKeyPath: "importantness") as? Bool,
            let urgency = task.value(forKeyPath: "urgency") as? Bool else {
                return
        }

        nameTextField.text = name
        urgentSwitch.isOn = urgency
        importantSwitch.isOn = importantness
    }

    // Cancel Action
    @IBAction func cancelToWorkoutViewController(_ segue: UIStoryboardSegue) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Make keyboard go away when Enter is pressed
    func textFieldShouldReturn(_ name: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        return true
    }
}
