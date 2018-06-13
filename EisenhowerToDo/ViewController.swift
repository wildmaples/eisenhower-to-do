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
    var selectedTableView = UITableView()
    
    // Outlets for the four table views
    @IBOutlet weak var completedTasksTableView: UITableView!
    @IBOutlet weak var newTaskButton: UIButton!
    @IBOutlet weak var nImportantUrgentTableView: UITableView!
    @IBOutlet weak var importantUrgentTableView: UITableView!
    
    // MARK: - VC Stuff
    
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
    
    // Reload views to view newly created sample task
    override func viewDidAppear(_ animated: Bool) {
        importantUrgentTableView?.reloadData()
        nImportantUrgentTableView?.reloadData()
        completedTasksTableView?.reloadData()
    }
    
    // MARK: - tableView for VC
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedIndex = indexPath.row
        let vc = storyboard?.instantiateViewController(withIdentifier: "ModifyTaskViewController") as! ModifyTaskViewController
        if tableView == self.importantUrgentTableView {
            vc.task = tasksTT[selectedIndex]
        } else if tableView == self.nImportantUrgentTableView {
            vc.task = tasksFT[selectedIndex]
        }
        present(vc, animated: true, completion: nil)
        
    }
    
    // MARK: - IBActions
    
    // Receiving newtask to categorize
    @IBAction func createTaskSegue(_ segue: UIStoryboardSegue) {
        
        let vc = segue.source as? AddTaskViewController
        let createdTask = Task()
        createdTask.name = (vc?.name.text!)!
        createdTask.urgency = (vc?.urgentSwitch.isOn)!
        createdTask.importantness = (vc?.importantSwitch.isOn)!
        createdTask.done = false
        
        categorizeTask(task: createdTask)
        
        // Check if new task's name is appended to the list
        print(createdTask.name )
        print(tasksTT)
        
    }
    
    @IBAction func modifyTaskSegue(_ segue: UIStoryboardSegue) {
        let vc = segue.source as? ModifyTaskViewController
        let task = vc?.task
        removeTask(task: task!)
        task?.importantness = (vc?.importantSwitch.isOn)!
        task?.urgency = (vc?.urgentSwitch.isOn)!
        task?.name = vc?.name.text
        categorizeTask(task: task!)
    }
    
    // MARK: - TableView Delegate Functions
    
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
    func mark(task: Task) {
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
            if tasksTT.contains(task) == false {
                tasksTT.append(task)
                importantUrgentTableView.reloadData()
            }
        } else if task.urgency == true && task.importantness == false {
            if tasksFT.contains(task) == false {
                tasksFT.append(task)
                nImportantUrgentTableView.reloadData()
            }
        }
    }
    
}

