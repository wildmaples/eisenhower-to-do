//
//  AddTaskViewController.swift
//  EisenhowerToDo
//
//  Created by Maple Ong on 5/31/18.
//  Copyright © 2018 MO. All rights reserved.
//

import UIKit

class AddTaskViewController: UIViewController {
    
    @IBOutlet weak var importantSwitch: UISwitch!
    @IBOutlet weak var urgentSwitch: UISwitch!
    @IBOutlet weak var name: UITextField!
    
    
    // Cancel Action
    @IBAction func cancelToWorkoutViewController(_ segue: UIStoryboardSegue) {
        self.dismiss(animated: true, completion: nil)
    }
}
