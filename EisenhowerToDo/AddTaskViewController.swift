//
//  AddTaskViewController.swift
//  EisenhowerToDo
//
//  Created by Maple Ong on 5/31/18.
//  Copyright © 2018 MO. All rights reserved.
//

import UIKit

class AddTaskViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var importantSwitch: UISwitch!
    @IBOutlet weak var urgentSwitch: UISwitch!
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameTextField.delegate = self
    }

    // Cancel Action
    @IBAction func cancelToTaskViewController(_ segue: UIStoryboardSegue) {
        self.dismiss(animated: true, completion: nil)
    }

    // Make keyboard go away when Enter is pressed
    func textFieldShouldReturn(_ name: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        return true
    }
}
