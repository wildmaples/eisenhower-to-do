//
//  ViewController.swift
//  EisenhowerToDo
//
//  Created by Maple Ong on 5/30/18.
//  Copyright © 2018 MO. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // sample data gen
    var tasksTT = SampleData.generateTT()
    var tasksFT = SampleData.generateFT()
    var createdTask: Task?
    var all_done_tasks: [Task] = []
    
    
    // Outlets for the four table views
    @IBOutlet weak var completedTasksTableView: UITableView!
    @IBOutlet weak var newTaskButton: UIButton!
    @IBOutlet weak var nImportantUrgentTableView: UITableView!
    @IBOutlet weak var importantUrgentTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        importantUrgentTableView.delegate = self
        importantUrgentTableView.dataSource = self
        nImportantUrgentTableView.delegate = self
        nImportantUrgentTableView.dataSource = self
        completedTasksTableView.delegate = self
        completedTasksTableView.dataSource = self
        
        //
        for list in [tasksTT, tasksFT] {
            for task in list {
                if task.done == true {
                    all_done_tasks.append(task)
                }
            }
        }
        print (all_done_tasks[0].name)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // returns # of rows in each tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberOfRowsInSection called")
        var count = 0
        if tableView == self.importantUrgentTableView {
            count = tasksTT.count
                }
        
        else if tableView == self.nImportantUrgentTableView {
            count = tasksFT.count
        }
        
        else if tableView == self.completedTasksTableView {
            count = all_done_tasks.count
        }

        
        return count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // for each tableview, load cells
        if tableView == self.importantUrgentTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImportantUrgentCell", for: indexPath) as! ImportantUrgentTableViewCell
            let task = tasksTT[indexPath.row]
            cell.setup(task: task)
            cell.task = task
            print("1. \(task.name)")
            return cell
        }
    
        else if tableView == self.nImportantUrgentTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NImportantUrgentCell", for: indexPath) as! NImportantUrgentTableViewCell
            let task = tasksFT[indexPath.row]
            cell.setup(task: task)
            print("2: \(task.name)")
            return cell
        }
        
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DoneCell", for: indexPath)
            let task = all_done_tasks[indexPath.row]
            cell.textLabel?.text = task.name
            print("3. \(String(describing: cell.textLabel?.text))")
            return cell
        }
        
    }
    
    // receiving newtask to categorize
    @IBAction func createTaskSegue(_ segue: UIStoryboardSegue) {
        
        let vc = segue.source as? AddTaskViewController
        let createdTask = Task()
        createdTask.name = (vc?.name.text!)!
        createdTask.importantness = (vc?.importantSwitch.isOn)!
        createdTask.urgency = (vc?.urgentSwitch.isOn)!
        createdTask.done = false
        print ("This is \(createdTask)")
        
        // Append to the appropriate list
        if createdTask.urgency == true && createdTask.importantness == true {
            tasksTT.append(createdTask)
        }
            
        else if createdTask.urgency == true && createdTask.importantness == false {
            tasksFT.append(createdTask)
        }
        
        // Check if name is appended to the list
        print(createdTask.name )
        print(tasksTT)
        
        
    }
    // reload view to view newly created task
    override func viewDidAppear(_ animated: Bool) {
        self.importantUrgentTableView?.reloadData()
    }

//    // done-toggle
//    @IBAction func doneToggle(_ sender: Any) {
//        if task.done == true {
//            task.done = false
//        }
//        else {
//            task.done = true
//        }
//        print("\(task.done)")
//    }
//

}

protocol UpdateDelegate: class {
    func didUpdate(sender: Any)
}

extension ViewController: UpdateDelegate {
    func didUpdate(sender: Any) {
        completedTasksTableView.reloadData()
        print ("UpdateDelegate worked!")
    }
}


