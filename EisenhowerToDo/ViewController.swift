//
//  ViewController.swift
//  EisenhowerToDo
//
//  Created by Maple Ong on 5/30/18.
//  Copyright © 2018 MO. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TaskCellDelegate {
    
    // MARK: - Outlets and sample data variables
    
    var tasksTT = SampleData.generateTT()
    var tasksFT = SampleData.generateFT()
    var tasksTF = SampleData.generateTF()
    var tasksFF = SampleData.generateFF()
    var allDoneTasks: [Task] = []
    
    // Outlets for the four table views
    @IBOutlet weak var completedTasksTableView: UITableView!
    @IBOutlet weak var newTaskButton: UIButton!
    @IBOutlet weak var nImportantUrgentTableView: UITableView!
    @IBOutlet weak var importantUrgentTableView: UITableView!
    @IBOutlet weak var nImportantNUrgentTableView: UITableView!
    @IBOutlet weak var importantNUrgentTableView: UITableView!
    @IBOutlet weak var arrowIcon: UIImageView!
    
    // MARK: - VC Stuff
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        importantUrgentTableView.delegate = self
        importantUrgentTableView.dataSource = self
        nImportantUrgentTableView.delegate = self
        nImportantUrgentTableView.dataSource = self
        nImportantNUrgentTableView.delegate = self
        nImportantNUrgentTableView.dataSource = self
        importantNUrgentTableView.delegate = self
        importantNUrgentTableView.dataSource = self
        completedTasksTableView.delegate = self
        completedTasksTableView.dataSource = self
        
        importantUrgentTableView.register(UINib(nibName: "TaskCell", bundle: nil), forCellReuseIdentifier: "TaskCell")
        nImportantUrgentTableView.register(UINib(nibName: "TaskCell", bundle: nil), forCellReuseIdentifier: "TaskCell")
        importantNUrgentTableView.register(UINib(nibName: "TaskCell", bundle: nil), forCellReuseIdentifier: "TaskCell")
        nImportantNUrgentTableView.register(UINib(nibName: "TaskCell", bundle: nil), forCellReuseIdentifier: "TaskCell")
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
        } else if tableView == self.importantNUrgentTableView {
            count = tasksTF.count
        } else if tableView == self.nImportantNUrgentTableView {
            count = tasksFF.count
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
            cell.backgroundColor = UIColor(rgb: 0x009E0F)
            return cell
            
        } else if tableView == self.nImportantUrgentTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCellTableViewCell
            let task = tasksFT[indexPath.row]
            cell.setup(task: task)
            cell.delegate = self
            cell.backgroundColor = UIColor(rgb: 0xFF9900)
            return cell
            
        } else if tableView == self.importantNUrgentTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCellTableViewCell
            let task = tasksTF[indexPath.row]
            cell.setup(task: task)
            cell.delegate = self
            cell.backgroundColor = UIColor(rgb: 0x2b78e4)
            return cell
            
        } else if tableView == self.nImportantNUrgentTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCellTableViewCell
            let task = tasksFF[indexPath.row]
            cell.setup(task: task)
            cell.delegate = self
            cell.backgroundColor = UIColor(rgb: 0x999999)
            return cell
            
            // Completed task tableview
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCellTableViewCell
            let task = allDoneTasks[indexPath.row]
            cell.setup(task: task)
            cell.delegate = self
            let color = disabledColor(task: task)
            cell.backgroundColor = UIColor(rgb: color)
            return cell
        }
    }
    
    // When a row is clicked
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedIndex = indexPath.row
        let vc = storyboard?.instantiateViewController(withIdentifier: "ModifyTaskViewController") as! ModifyTaskViewController
        
        if tableView == self.importantUrgentTableView {
            vc.task = tasksTT[selectedIndex]
        } else if tableView == self.nImportantUrgentTableView {
            vc.task = tasksFT[selectedIndex]
        } else if tableView == self.importantNUrgentTableView {
            vc.task = tasksTF[selectedIndex]
        } else if tableView == self.nImportantNUrgentTableView {
            vc.task = tasksFF[selectedIndex]
        } else {
            vc.task = allDoneTasks[selectedIndex]
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
        categorizeTask(task: createdTask)
    }
    
    // shows completed tasks tableview on click
    @IBAction func completedTasksButton(_ sender: Any) {
        if completedTasksTableView.isHidden {
            completedTasksTableView.isHidden = false
            self.arrowIcon.image = UIImage(named: "arrowUp")
        } else {
            completedTasksTableView.isHidden = true
            self.arrowIcon.image = UIImage(named: "arrowDown")
        }
    }
    
    @IBAction func modifyTaskSegue(_ segue: UIStoryboardSegue) {
        let vc = segue.source as? ModifyTaskViewController
        let task = vc?.task
        
        // if modified task has changed
        if task?.importantness != (vc?.importantSwitch.isOn)! || (task?.urgency)! != (vc?.urgentSwitch.isOn)! {
            removeTask(task: task!)
            task?.importantness = (vc?.importantSwitch.isOn)!
            task?.urgency = (vc?.urgentSwitch.isOn)!
            task?.name = vc?.name.text
            categorizeTask(task: task!)
            
        // if it hasn't changed just update the text
        } else {
            task?.name = vc?.name.text
            didUpdate()
        }
    }
    
    // MARK: - TableView Delegate Functions
    
    // remove task for non-done tasks
    func removeTask(task: Task) {
        if let index = allDoneTasks.index(of: task), allDoneTasks.contains(task) {
            allDoneTasks.remove(at: index)
            completedTasksTableView.reloadData()
        } else {
            if task.urgency == true && task.importantness == true {
                if let index = tasksTT.index(of: task){
                    tasksTT.remove(at: index)
                    importantUrgentTableView.reloadData()
                }
            } else if task.urgency == true {
                if let index = tasksFT.index(of: task) {
                    tasksFT.remove(at: index)
                    nImportantUrgentTableView.reloadData()
                }
            } else if task.importantness == true {
                if let index = tasksTF.index(of: task) {
                    tasksTF.remove(at: index)
                    importantNUrgentTableView.reloadData()
                }
            } else {
                if let index = tasksFF.index(of: task) {
                    tasksFF.remove(at: index)
                    nImportantNUrgentTableView.reloadData()
                }
            }
        }
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
        if task.done == true {
            if allDoneTasks.contains(task) == false {
                allDoneTasks.append(task)
                completedTasksTableView.reloadData()
            }
        } else {
            if task.urgency == true && task.importantness == true {
                if tasksTT.contains(task) == false {
                    tasksTT.append(task)
                    importantUrgentTableView.reloadData()
                }
            } else if task.urgency == true {
                if tasksFT.contains(task) == false {
                    tasksFT.append(task)
                    nImportantUrgentTableView.reloadData()
                }
            } else if task.importantness == true {
                if tasksTF.contains(task) == false {
                    tasksTF.append(task)
                    importantNUrgentTableView.reloadData()
                }
            } else {
                if tasksFF.contains(task) == false {
                    tasksFF.append(task)
                    nImportantNUrgentTableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Additional functions
    
    // returns muted color for completed tasks table based on task type
    func disabledColor(task: Task) -> Int {
        if task.importantness == true && task.urgency == true {
            return 0x6aa84f
        } else if task.urgency == true {
            return 0xf6b26b
        } else if task.importantness == true {
            return 0x6fa8dc
        } else {
            return 0xcccccc
        }
    }
    
    // refresh all tableviews
    func didUpdate() {
        importantUrgentTableView.reloadData()
        nImportantUrgentTableView.reloadData()
        importantNUrgentTableView.reloadData()
        nImportantNUrgentTableView.reloadData()
        completedTasksTableView.reloadData()
    }
    
}

// Extension for UIColor
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

