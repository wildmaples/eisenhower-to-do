//
//  ViewController.swift
//  EisenhowerToDo
//
//  Created by Maple Ong on 5/30/18.
//  Copyright © 2018 MO. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UpdateDelegate {

    // sample data gen
    var tasksTT = SampleData.generateTT()
    var tasksFT = SampleData.generateFT()
    var createdTask: Task?
    var all_done_tasks: [Task] = []
    var toggledTask: Task!
    var selectedIndex = Int()
    
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
        

        importantUrgentTableView.register(UINib(nibName: "TaskCell", bundle: nil), forCellReuseIdentifier: "TaskCell")
        nImportantUrgentTableView.register(UINib(nibName: "TaskCell", bundle: nil), forCellReuseIdentifier: "TaskCell")
        completedTasksTableView.register(UINib(nibName: "TaskCell", bundle: nil), forCellReuseIdentifier: "TaskCell")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // returns # of rows in each tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if tableView == self.importantUrgentTableView {
            count = (omitDone(task_list: tasksTT)).count
        } else if tableView == self.nImportantUrgentTableView {
            count = (omitDone(task_list: tasksFT)).count
        } else if tableView == self.completedTasksTableView {
            count = all_done_tasks.count
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // for each tableview, load cells
        if tableView == self.importantUrgentTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCellTableViewCell
            let task = (omitDone(task_list: tasksTT))[indexPath.row]
            cell.setup(task: task)
            cell.task = task
            cell.delegate = self
            cell.index = indexPath.row
            //print("1. \(task.name)")
            return cell
            
        } else if tableView == self.nImportantUrgentTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCellTableViewCell
            let task = (omitDone(task_list: tasksFT))[indexPath.row]
            cell.setup(task: task)
            cell.task = task
            cell.delegate = self
            cell.index = indexPath.row
            //print("2: \(task.name)")
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCellTableViewCell
            let task = all_done_tasks[indexPath.row]
            cell.setup(task: task)
            cell.task = task
            cell.delegate = self
            cell.index = indexPath.row
            //print("3. \(String(describing: cell.textLabel?.text))")
            return cell
        }
        
    }
    
    // Receiving newtask to categorize
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
        } else if createdTask.urgency == true && createdTask.importantness == false {
            tasksFT.append(createdTask)
        }
        
        // Check if name is appended to the list
        print(createdTask.name )
        print(tasksTT)
        
        
    }
    // Reload view to view newly created task
    override func viewDidAppear(_ animated: Bool) {
        self.importantUrgentTableView?.reloadData()
    }

    @IBAction func modifyTaskSegue(_ segue: UIStoryboardSegue) {
        
        let vc = segue.source as? ModifyTaskViewController
        let task = Task()
        task.name = (vc?.name.text!)!
        task.importantness = (vc?.importantSwitch.isOn)!
        task.urgency = (vc?.urgentSwitch.isOn)!
        task.done = false
        print ("This is \(task)")
        
        // Edit task in appropriate list
        if task.urgency == true && task.importantness == true {
            tasksTT.append(task)
        } else if task.urgency == true && task.importantness == false {
            tasksFT.append(task)
        }
        
        // Check if name is appended to the list
        print(task.name )
        print(tasksTT)
        
        
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        self.performSegue(withIdentifier: "ModifySegueTT", sender: indexPath)
        self.performSegue(withIdentifier: "ModifySegueFT", sender: indexPath)

        print(selectedIndex)
    }
//
//
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ModifySegueTT"{
            let vc : ModifyTaskViewController = segue.destination as! ModifyTaskViewController
            vc.task = omitDone(task_list:tasksTT)[selectedIndex]
            navigationController?.pushViewController(vc, animated: true)
        } else if segue.identifier == "ModifySegueFT" {
            let vc : ModifyTaskViewController = segue.destination as! ModifyTaskViewController
            vc.task = omitDone(task_list:tasksFT)[selectedIndex]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // Functions (used in delegation)
    func didUpdate(sender: Any) {
        
        
        // update list view
        for list in [tasksTT, tasksFT] {
            for task in list {
                if task.done == true {
                    all_done_tasks.append(task)
                    
                }
            }
        }
        
        // reload all views
        self.completedTasksTableView.reloadData()
        print ("UpdateDelegate worked!")
    }
    
    func removeTask(sender: Any, task: Task, row: IndexPath) {
        
        // check which task it is
        if task.urgency == true && task.importantness == true {
            let indexPath = row
            tasksTT.remove(at: indexPath.row)
            importantUrgentTableView.reloadData()
            
            } else if task.urgency == true && task.importantness == false {
            let indexPath = row
            tasksFT.remove(at: indexPath.row)
            nImportantUrgentTableView.reloadData()
        }
        
//        // updates completed task tableview
//        didUpdate(sender: self)
    }
    
    // function to create a list that contains items that are not done
    func omitDone(task_list: [Task]) -> [Task] {
        var notdone : [Task] = []
        for task in task_list {
            if task.done == false {
            notdone.append(task)
            }
        }
        return notdone
    }
    
}

// Protocol for delegation
protocol UpdateDelegate: class {
    func didUpdate(sender: Any)
    func removeTask(sender: Any, task: Task, row: IndexPath)
}

