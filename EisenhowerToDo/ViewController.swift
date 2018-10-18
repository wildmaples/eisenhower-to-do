//
//  ViewController.swift
//  EisenhowerToDo
//
//  Created by Maple Ong on 5/30/18.
//  Copyright © 2018 MO. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TaskCellDelegate {

    // Outlets for the four table views
    @IBOutlet weak var completedTasksTableView: UITableView!
    @IBOutlet weak var newTaskButton: UIButton!
    @IBOutlet weak var nImportantUrgentTableView: UITableView!
    @IBOutlet weak var importantUrgentTableView: UITableView!
    @IBOutlet weak var nImportantNUrgentTableView: UITableView!
    @IBOutlet weak var importantNUrgentTableView: UITableView!
    @IBOutlet weak var arrowIcon: UIImageView!
    
    var importantUrgentList = [Task]()
    var nImportantUrgentList = [Task]()
    var importantNUrgentList = [Task]()
    var nImportantNUrgentList = [Task]()
    var allDoneTasks = [Task]()
    var taskManager: TaskManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        self.taskManager = TaskManager(persistentContainer: appDelegate.persistentContainer)
        
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
        
        ///// To Generate Sample Data at first load
//        SampleData.generateTT(taskManager: taskManager)
//        SampleData.generateTF(taskManager: taskManager)
//        SampleData.generateFT(taskManager: taskManager)
//        SampleData.generateFF(taskManager: taskManager)
        
        fetchFromCoreData()
    }

    // Reload views to view newly created sample task
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
//        didUpdate()
    }
    
    // MARK: - TableView
    
    // Return one row for each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // Each Section has
    func numberOfSections(in tableView: UITableView) -> Int {
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
    
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5.0
    }
    
    // Make the background color in header and footer show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clear
        return footerView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // For each tableview, load cells
        if tableView == self.importantUrgentTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCellTableViewCell
            let task = importantUrgentList[indexPath.section]
            cell.task = task
            cell.setup()
            cell.delegate = self
            cell.backgroundColor = UIColor(rgb: 0x009E0F)
            return cell
            
        } else if tableView == self.nImportantUrgentTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCellTableViewCell
            let task = nImportantUrgentList[indexPath.section]
            cell.task = task
            cell.setup()
            cell.delegate = self
            cell.backgroundColor = UIColor(rgb: 0xFF9900)
            return cell
            
        } else if tableView == self.importantNUrgentTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCellTableViewCell
            let task = importantNUrgentList[indexPath.section]
            cell.task = task
            cell.setup()
            cell.delegate = self
            cell.backgroundColor = UIColor(rgb: 0x2b78e4)
            return cell
            
        } else if tableView == self.nImportantNUrgentTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCellTableViewCell
            let task = nImportantNUrgentList[indexPath.section]
            cell.task = task
            cell.setup()
            cell.delegate = self
            cell.backgroundColor = UIColor(rgb: 0x999999)
            return cell
            
            // Completed task tableview
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCellTableViewCell
            let task = allDoneTasks[indexPath.section]
            cell.task = task
            cell.setup()
            cell.delegate = self
            let color = disabledColor(task: task)
            cell.backgroundColor = UIColor(rgb: color)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedIndex = indexPath.section
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
        guard let vc = segue.source as? AddTaskViewController else {
            return
        }
        taskManager.save(name: vc.nameTextField.text ?? " ", done: false, urgency: vc.urgentSwitch.isOn, importantness: vc.importantSwitch.isOn)
        fetchAndRefreshAllTableViews()
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
        
        guard let task = vc.task,
            let done = task.value(forKey: "done") as? Bool else {
                return
        }
        
        task.setValue(vc.urgentSwitch.isOn, forKey: "urgency")
        task.setValue(vc.importantSwitch.isOn, forKey: "importantness")
        task.setValue(vc.nameTextField.text, forKey: "name")
        task.setValue(done, forKey: "done")
        
        taskManager.saveContext()
        fetchAndRefreshAllTableViews()
    }
    
    // MARK: - TableView Delegate Functions
    
    // remove/delete task 
    func removeTask(task: Task) {
        if let index = allDoneTasks.index(of: task), allDoneTasks.contains(task) {
            allDoneTasks.remove(at: index)
            completedTasksTableView.reloadData()
        }
        
        if task.urgency && task.importantness {
            if let index = importantUrgentList.index(of: task) {
                importantUrgentList.remove(at: index)
                importantUrgentTableView.reloadData()
            }
        } else if task.urgency {
            if let index = nImportantUrgentList.index(of: task) {
                nImportantUrgentList.remove(at: index)
                nImportantUrgentTableView.reloadData()
            }
        } else if task.importantness {
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
        
        taskManager.delete(task: task)
        fetchAndRefreshAllTableViews()
    }
    
    // Toggle completed tasks 
    func toggleDone(task: Task) {
        taskManager.toggleDone(task: task)
        fetchAndRefreshAllTableViews()
    }

    // MARK: - Additional functions
    
    // TODO: Move this func somewhere else
    // Returns muted color for completed tasks table based on task type
    func disabledColor(task: NSManagedObject) -> Int {
        guard let importantness = task.value(forKey: "importantness") as? Bool,
            let urgency = task.value(forKey: "urgency") as? Bool else {
            return 0
        }
        
        if importantness == true && urgency == true {
            return 0x6aa84f
        } else if urgency == true {
            return 0xf6b26b
        } else if importantness == true {
            return 0x6fa8d
        } else {
            return 0xcccccc
        }
    }
    
    func fetchFromCoreData() {
        importantUrgentList = taskManager.fetch(done: false, urgency: true, importantness: true)
        nImportantUrgentList = taskManager.fetch(done: false, urgency: true, importantness: false)
        importantNUrgentList = taskManager.fetch(done: false, urgency: false, importantness: true)
        nImportantNUrgentList = taskManager.fetch(done: false, urgency: false, importantness: false)
        allDoneTasks = taskManager.fetch(done: true)
    }

    // refresh all tableviews
    func fetchAndRefreshAllTableViews() {
        fetchFromCoreData()
        importantUrgentTableView.reloadData()
        nImportantUrgentTableView.reloadData()
        importantNUrgentTableView.reloadData()
        nImportantNUrgentTableView.reloadData()
        completedTasksTableView.reloadData()
    }
}
