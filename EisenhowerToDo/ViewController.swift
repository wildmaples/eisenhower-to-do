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
    
    var importantUrgentList = SampleData.generateTT()
    var nImportantUrgentList = SampleData.generateFT()
    var importantNUrgentList = SampleData.generateTF()
    var nImportantNUrgentList = SampleData.generateFF()
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
            count = importantUrgentList.count
        } else if tableView == self.nImportantUrgentTableView {
            count = nImportantUrgentList.count
        } else if tableView == self.importantNUrgentTableView {
            count = importantNUrgentList.count
        } else if tableView == self.nImportantNUrgentTableView {
            count = nImportantNUrgentList.count
        } else if tableView == self.completedTasksTableView {
            count = allDoneTasks.count
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // For each tableview, load cells
        if tableView == self.importantUrgentTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCellTableViewCell
            let task = importantUrgentList[indexPath.row]
            cell.setup(task: task)
            cell.delegate = self
            cell.backgroundColor = UIColor(rgb: 0x009E0F)
            return cell
            
        } else if tableView == self.nImportantUrgentTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCellTableViewCell
            let task = nImportantUrgentList[indexPath.row]
            cell.setup(task: task)
            cell.delegate = self
            cell.backgroundColor = UIColor(rgb: 0xFF9900)
            return cell
            
        } else if tableView == self.importantNUrgentTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCellTableViewCell
            let task = importantNUrgentList[indexPath.row]
            cell.setup(task: task)
            cell.delegate = self
            cell.backgroundColor = UIColor(rgb: 0x2b78e4)
            return cell
            
        } else if tableView == self.nImportantNUrgentTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCellTableViewCell
            let task = nImportantNUrgentList[indexPath.row]
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
            vc.task = importantUrgentList[selectedIndex]
        } else if tableView == self.nImportantUrgentTableView {
            vc.task = nImportantUrgentList[selectedIndex]
        } else if tableView == self.importantNUrgentTableView {
            vc.task = importantNUrgentList[selectedIndex]
        } else if tableView == self.nImportantNUrgentTableView {
            vc.task = nImportantNUrgentList[selectedIndex]
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
        createdTask.name = (vc?.nameTextField.text!)!
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
        let vc = segue.source as! ModifyTaskViewController
        let task : Task! = vc.task

        // if modified task has changed
        if task.importantness != vc.importantSwitch.isOn || task.urgency != vc.urgentSwitch.isOn {
            removeTask(task: task!)
            task.importantness = vc.importantSwitch.isOn
            task.urgency = vc.urgentSwitch.isOn
            task.name = vc.nameTextField.text
            categorizeTask(task: task!)
            
        // if it hasn't changed just update the text
        } else {
            task.name = vc.nameTextField.text
            didUpdate()
        }
    }
    
    // MARK: - TableView Delegate Functions
    
    // remove/delete task 
    func removeTask(task: Task) {
        if let index = allDoneTasks.index(of: task), allDoneTasks.contains(task) {
            allDoneTasks.remove(at: index)
            completedTasksTableView.reloadData()
        } else if task.urgency == true && task.importantness == true {
            if let index = importantUrgentList.index(of: task){
                importantUrgentList.remove(at: index)
                importantUrgentTableView.reloadData()
            }
        } else if task.urgency == true {
            if let index = nImportantUrgentList.index(of: task) {
                nImportantUrgentList.remove(at: index)
                nImportantUrgentTableView.reloadData()
            }
        } else if task.importantness == true {
            if let index = importantNUrgentList.index(of: task) {
                importantNUrgentList.remove(at: index)
                importantNUrgentTableView.reloadData()
            }
        } else {
            if let index = nImportantNUrgentList.index(of: task) {
                nImportantNUrgentList.remove(at: index)
                nImportantNUrgentTableView.reloadData()
            }
        }
    }


    // appends a done task to allDoneTasks list
    func toggleDone(task: Task) {
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
        } else if task.urgency == true && task.importantness == true {
            if importantUrgentList.contains(task) == false {
                importantUrgentList.append(task)
                importantUrgentTableView.reloadData()
            }
        } else if task.urgency == true {
            if nImportantUrgentList.contains(task) == false {
                nImportantUrgentList.append(task)
                nImportantUrgentTableView.reloadData()
            }
        } else if task.importantness == true {
            if importantNUrgentList.contains(task) == false {
                importantNUrgentList.append(task)
                importantNUrgentTableView.reloadData()
            }
        } else {
            if nImportantNUrgentList.contains(task) == false {
                nImportantNUrgentList.append(task)
                nImportantNUrgentTableView.reloadData()
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

