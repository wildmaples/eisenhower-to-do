//
//  ViewController.swift
//  EisenhowerToDo
//
//  Created by Maple Ong on 5/30/18.
//  Copyright © 2018 MO. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TaskCellDelegate {
    
    // Sample data gen
    var tasksTT = SampleData.generateTT()
    var tasksFT = SampleData.generateFT()
    var allDoneTasks: [Task] = []
    var selectedIndex = Int()
    var selectedTableView = UITableView()
    
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
    
    
    // returns # of rows in each tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if tableView == self.importantUrgentTableView {
            count = tasksTT.count
        } else if tableView == self.nImportantUrgentTableView {
            count = tasksFT.count
        } else if tableView == self.completedTasksTableView {
            count = allDoneTasks.count
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // For each tableview, load cells
        if tableView == self.importantUrgentTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCellTableViewCell
            let task = tasksTT[indexPath.row]
            cell.setup(task: task)
            cell.delegate = self
            cell.index = indexPath.row
            //print("1. \(task.name)")
            return cell
            
        } else if tableView == self.nImportantUrgentTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCellTableViewCell
            let task = tasksFT[indexPath.row]
            cell.setup(task: task)
            cell.delegate = self
            cell.index = indexPath.row
            //print("2: \(task.name)")
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCellTableViewCell
            let task = allDoneTasks[indexPath.row]
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
        createdTask.urgency = (vc?.urgentSwitch.isOn)!
        createdTask.importantness = (vc?.importantSwitch.isOn)!
        createdTask.done = false
        
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
    // Reload views to view newly created task
    override func viewDidAppear(_ animated: Bool) {
        importantUrgentTableView?.reloadData()
        nImportantUrgentTableView?.reloadData()
        completedTasksTableView?.reloadData()
        
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
            self.importantUrgentTableView.reloadData()
            
        } else if task.urgency == true && task.importantness == false {
            tasksFT.append(task)
            self.nImportantUrgentTableView.reloadData()
        }
        
        // Check if name is appended to the list
        print(task.name )
        print(tasksTT)
        
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        selectedTableView = tableView
        performSegue(withIdentifier: "ModifySegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ModifySegue" {
            if selectedTableView == self.importantUrgentTableView {
                let vc : ModifyTaskViewController = segue.destination as! ModifyTaskViewController
                vc.task = tasksTT[selectedIndex]
                removeTask(task: tasksTT[selectedIndex])
                navigationController?.pushViewController(vc, animated: true)
                
            } else if selectedTableView == self.nImportantUrgentTableView {
                let vc : ModifyTaskViewController = segue.destination as! ModifyTaskViewController
                vc.task = tasksFT[selectedIndex]
                removeTask(task: tasksFT[selectedIndex])
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    // remove task for non-done tasks
    func removeTask(task: Task) {
        if task.urgency == true && task.importantness == true {
            if let index = tasksTT.index(of: task) {
                tasksTT.remove(at: index)
            }
            importantUrgentTableView.reloadData()
        } else if task.urgency == true && task.importantness == false {
            if let index = tasksFT.index(of: task) {
                tasksFT.remove(at: index)
            }
            nImportantUrgentTableView.reloadData()
        }
    }
    
    // remove task for done tasks
    func removeDoneTask(task: Task) {
        if let index = allDoneTasks.index(of: task) {
            allDoneTasks.remove(at: index)
        }
        completedTasksTableView.reloadData()
    }
    
    // appends a done task to allDoneTasks list
    func mark(task: Task, asDone done: Bool) {
        if task.done {
            task.done = false
        } else {
            task.done = true
            allDoneTasks.append(task)
            completedTasksTableView.reloadData()
        }
    }
    
    func categorizeTask(task: Task) {
        if task.urgency == true && task.importantness == true {
            tasksTT.append(task)
            importantUrgentTableView.reloadData()
        } else if task.urgency == true && task.importantness == false {
            tasksFT.append(task)
            nImportantUrgentTableView.reloadData()
        }
    }
    
}

