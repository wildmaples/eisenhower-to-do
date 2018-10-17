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
    
    var task: Task!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var urgentSwitch: UISwitch!
    @IBOutlet weak var importantSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameTextField.delegate = self
        setUp()
    }
    
    private func setUp() {
        nameTextField.text = task.name
        urgentSwitch.isOn = task.urgency
        importantSwitch.isOn = task.importantness
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
