//
//  ViewController.swift
//  EisenhowerToDo
//
//  Created by Maple Ong on 5/30/18.
//  Copyright © 2018 MO. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // Sample data gen
    var tasksTT = SampleData.generateTT()
    var tasksFT = SampleData.generateFT()
    var createdTask: Task?
    
    // Outlets for the four table views
    @IBOutlet weak var newTaskButton: UIButton!
    @IBOutlet weak var nImportantUrgentTableView: UITableView?
    @IBOutlet weak var importantUrgentTableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        importantUrgentTableView?.delegate = self
        importantUrgentTableView?.dataSource = self
        nImportantUrgentTableView?.delegate = self
        nImportantUrgentTableView?.dataSource = self
    }


    // returns # of rows in each tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberOfRowsInSection called")
        var count = 0
        if tableView == self.importantUrgentTableView {
            //let found = tasks.filter{$0.importantness == false && $0.urgency == false}
            count = tasksTT.count
        } else if tableView == self.nImportantUrgentTableView {
            count = tasksFT.count
        }
        return count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell
        
        // For each tableview, load cells
        if tableView == self.importantUrgentTableView {
            let quad1 = tableView.dequeueReusableCell(withIdentifier: "ImportantUrgentCell", for: indexPath)
            let task = tasksTT[indexPath.row]
            quad1.textLabel?.text = task.name
            cell = quad1
        } else {
            let quad2 = tableView.dequeueReusableCell(withIdentifier: "NImportantUrgentCell", for: indexPath)
            let task = tasksFT[indexPath.row]
            quad2.textLabel?.text = task.name
            cell = quad2
        }
        return cell
    }
    
    // Receiving newtask to categorize
    @IBAction func createTaskSegue(_ segue: UIStoryboardSegue) {
        
        let vc = segue.source as? AddTaskViewController
        let createdTask = Task()
        createdTask.name = (vc?.name.text!)!
        createdTask.urgency = (vc?.urgentSwitch.isOn)!
        createdTask.importantness = (vc?.importantSwitch.isOn)!
        createdTask.done = false
        print ("This is \(createdTask)")
        
        // Append to the appropriate list
        if createdTask.urgency == true && createdTask.importantness == true {
            tasksTT.append(createdTask)
            
        } else if createdTask.urgency == true && createdTask.importantness == false {
            tasksFT.append(createdTask)
        }
        
        // Check if new task's name is appended to the list
        print(createdTask.name )
        print(tasksTT)
    }

    override func viewDidAppear(_ animated: Bool) {
        self.importantUrgentTableView?.reloadData()
    }
    
    

}

