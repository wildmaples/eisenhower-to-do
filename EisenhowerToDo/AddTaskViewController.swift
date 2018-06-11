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
    @IBOutlet weak var name: UITextField!
    
    
    // Cancel Action
    @IBAction func cancelToWorkoutViewController(_ segue: UIStoryboardSegue) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.name.delegate = self
    }

    // make keyboard go away
    func textFieldShouldReturn(_ name: UITextField) -> Bool {
        self.view.endEditing(true)
        name.resignFirstResponder()
        return true
    }

}
