//
//  ViewController.swift
//  EisenhowerToDo
//
//  Created by Maple Ong on 5/30/18.
//  Copyright © 2018 MO. All rights reserved.
//

import UIKit

// Protocol for delegation
protocol UpdateDelegate: class {
    func didUpdate(sender: Any)
    func removeTask(sender: Any, task: Task, row: IndexPath)
    func mark(task: Task, asDone done: Bool)
    func categorizeTask(task: Task)
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UpdateDelegate {

    // sample data gen
    var tasksTT = SampleData.generateTT()
    var tasksFT = SampleData.generateFT()
    var tasksTF = SampleData.generateTF()
    var tasksFF = SampleData.generateFF()

    var createdTask: Task?
    var all_done_tasks: [Task] = []
    var selectedIndex = Int()
    
    // Outlets for the four table views
    @IBOutlet weak var completedTasksTableView: UITableView!
    @IBOutlet weak var newTaskButton: UIButton!
    @IBOutlet weak var nImportantUrgentTableView: UITableView!
    @IBOutlet weak var importantUrgentTableView: UITableView!
    @IBOutlet weak var nImportantNUrgentTableView: UITableView!
    @IBOutlet weak var importantNUrgentTableView: UITableView!
    @IBOutlet weak var arrowIcon: UIImageView!
    
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

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
            count = all_done_tasks.count
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // for each tableview, load cells
        if tableView == self.importantUrgentTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCellTableViewCell
            let task = tasksTT[indexPath.row]
            cell.setup(task: task)
            cell.delegate = self
            cell.index = indexPath.row
            
            // cell color formatting/ style
            cell.backgroundColor = UIColor(rgb: 0x009E0F)
            return cell
            
        } else if tableView == self.nImportantUrgentTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCellTableViewCell
            let task = tasksFT[indexPath.row]
            cell.setup(task: task)
            cell.delegate = self
            cell.index = indexPath.row
            
            // cell color formatting/style
            cell.backgroundColor = UIColor(rgb: 0xFF9900)

            return cell
            
        } else if tableView == self.importantNUrgentTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCellTableViewCell
            let task = tasksTF[indexPath.row]
            cell.setup(task: task)
            cell.delegate = self
            cell.index = indexPath.row
            
            // cell color formatting/style
            cell.backgroundColor = UIColor(rgb: 0x2b78e4)
            
            return cell
            
        } else if tableView == self.nImportantNUrgentTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCellTableViewCell
            let task = tasksFF[indexPath.row]
            cell.setup(task: task)
            cell.delegate = self
            cell.index = indexPath.row
            
            // cell color formatting/style
            cell.backgroundColor = UIColor(rgb: 0x999999)
            
            return cell
        
        // Completed task tableview
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCellTableViewCell
            let task = all_done_tasks[indexPath.row]
            cell.setup(task: task)
            cell.delegate = self
            cell.index = indexPath.row
            
            // cell color formatting/style
            let color = disabledColor(task: task)
            cell.backgroundColor = UIColor(rgb: color)

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
        } else if createdTask.urgency == false && createdTask.importantness == true {
            tasksTF.append(createdTask)
        } else if createdTask.urgency == false && createdTask.importantness == false {
            tasksFF.append(createdTask)
        }
        
        self.didUpdate(sender: self)
        // Check if name is appended to the list
        print(createdTask.name )
        print(tasksTT)
        
        
    }
    // Reload views to view newly created task
    override func viewDidAppear(_ animated: Bool) {
        self.importantUrgentTableView?.reloadData()
        self.nImportantUrgentTableView?.reloadData()
        self.importantNUrgentTableView?.reloadData()
        self.nImportantNUrgentTableView?.reloadData()
        self.completedTasksTableView?.reloadData()

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
            
        } else if task.urgency == false && task.importantness == true {
            tasksTF.append(task)
            self.importantNUrgentTableView.reloadData()
            
        } else if task.urgency == false && task.importantness == false {
            tasksFF.append(task)
            self.nImportantNUrgentTableView.reloadData()
        }
        

        // Check if name is appended to the list
        print(task.name )
        print(tasksTT)
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

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        
        if tableView == self.importantUrgentTableView {
            self.performSegue(withIdentifier: "ModifySegueTT", sender: indexPath)
        } else if tableView == self.nImportantUrgentTableView {
            self.performSegue(withIdentifier: "ModifySegueFT", sender: indexPath)
        } else if tableView == self.importantNUrgentTableView {
            self.performSegue(withIdentifier: "ModifySegueTF", sender: indexPath)
        } else if tableView == self.nImportantNUrgentTableView {
            self.performSegue(withIdentifier: "ModifySegueFF", sender: indexPath)
        }

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let indexPath = IndexPath(row: selectedIndex, section:0)
        
        if segue.identifier == "ModifySegueTT"{
            let vc : ModifyTaskViewController = segue.destination as! ModifyTaskViewController
            vc.task = tasksTT[selectedIndex]
            removeTask(sender: (Any).self, task: tasksTT[selectedIndex], row: indexPath as IndexPath)
            navigationController?.pushViewController(vc, animated: true)
            
        } else if segue.identifier == "ModifySegueFT" {
            let vc : ModifyTaskViewController = segue.destination as! ModifyTaskViewController
            vc.task = tasksFT[selectedIndex]
            removeTask(sender: (Any).self, task: tasksFT[selectedIndex], row: indexPath as IndexPath)
            navigationController?.pushViewController(vc, animated: true)
            
        } else if segue.identifier == "ModifySegueTF" {
            let vc : ModifyTaskViewController = segue.destination as! ModifyTaskViewController
            vc.task = tasksTF[selectedIndex]
            removeTask(sender: (Any).self, task: tasksTF[selectedIndex], row: indexPath as IndexPath)
            navigationController?.pushViewController(vc, animated: true)
            
        } else if segue.identifier == "ModifySegueFF" {
            let vc : ModifyTaskViewController = segue.destination as! ModifyTaskViewController
            vc.task = tasksFF[selectedIndex]
            removeTask(sender: (Any).self, task: tasksFF[selectedIndex], row: indexPath as IndexPath)
            navigationController?.pushViewController(vc, animated: true)
        }

    }
    
    // Functions (used in delegation)
    func didUpdate(sender: Any) {
        // reload all views
        self.completedTasksTableView.reloadData()
        self.importantUrgentTableView.reloadData()
        self.importantNUrgentTableView.reloadData()
        self.nImportantNUrgentTableView.reloadData()

        self.nImportantUrgentTableView.reloadData()
        print ("tables refreshed!")
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
            } else if task.urgency == false && task.importantness == true {
                let indexPath = row
                tasksTF.remove(at: indexPath.row)
                importantNUrgentTableView.reloadData()
            } else if task.urgency == false && task.importantness == false {
                let indexPath = row
                tasksFF.remove(at: indexPath.row)
                nImportantNUrgentTableView.reloadData()
            }
        }
    
    
    // appends a done task to all_done list
    func mark(task: Task, asDone done: Bool) {
        if task.done {
            all_done_tasks.append(task)
        } else {
            all_done_tasks.remove(task)
        }
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
    
    func categorizeTask(task: Task) {
        if task.urgency == true && task.importantness == true {
            tasksTT.append(task)
        } else if task.urgency == true && task.importantness == false {
            tasksFT.append(task)
        } else if task.urgency == false && task.importantness == true {
            tasksTF.append(task)
        } else if task.urgency == false && task.importantness == false {
            tasksFF.append(task)
        }
    }
    
    // returns color for completed tasks table based on task type
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
    

}


// To remove Class from a list
extension Array where Element: AnyObject {
    mutating func remove(_ object: AnyObject) {
        if let index = index(where: { $0 === object }) {
            remove(at: index)
        }
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

