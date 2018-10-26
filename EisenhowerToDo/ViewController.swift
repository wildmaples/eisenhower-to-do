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
    @IBOutlet weak var arrowIcon: UIImageView!

    @IBOutlet weak var importantUrgentTableView: UITableView!
    @IBOutlet weak var notImportantUrgentTableView: UITableView!
    @IBOutlet weak var notImportantNotUrgentTableView: UITableView!
    @IBOutlet weak var importantNotUrgentTableView: UITableView!
    
    var importantUrgentList = [Task]()
    var notImportantUrgentList = [Task]()
    var importantNotUrgentList = [Task]()
    var notImportantNotUrgentList = [Task]()
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
        notImportantUrgentTableView.delegate = self
        notImportantUrgentTableView.dataSource = self
        notImportantNotUrgentTableView.delegate = self
        notImportantNotUrgentTableView.dataSource = self
        importantNotUrgentTableView.delegate = self
        importantNotUrgentTableView.dataSource = self
        completedTasksTableView.delegate = self
        completedTasksTableView.dataSource = self
        
        importantUrgentTableView.register(UINib(nibName: "TaskCell", bundle: nil), forCellReuseIdentifier: "TaskCell")
        notImportantUrgentTableView.register(UINib(nibName: "TaskCell", bundle: nil), forCellReuseIdentifier: "TaskCell")
        importantNotUrgentTableView.register(UINib(nibName: "TaskCell", bundle: nil), forCellReuseIdentifier: "TaskCell")
        notImportantNotUrgentTableView.register(UINib(nibName: "TaskCell", bundle: nil), forCellReuseIdentifier: "TaskCell")
        completedTasksTableView.register(UINib(nibName: "TaskCell", bundle: nil), forCellReuseIdentifier: "TaskCell")
        
        // To Generate Sample Data at first load
//        SampleData.generateTT(taskManager: taskManager)
//        SampleData.generateTF(taskManager: taskManager)
//        SampleData.generateFT(taskManager: taskManager)
//        SampleData.generateFF(taskManager: taskManager)
    }

    // Reload views to view newly created sample task
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        fetchAndRefreshAllTableViews()
    }
    
    // MARK: - TableView
    
    // Return one row for each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var count = 0
        if tableView == self.importantUrgentTableView {
            count = importantUrgentList.count
        } else if tableView == self.notImportantUrgentTableView {
            count = notImportantUrgentList.count
        } else if tableView == self.importantNotUrgentTableView {
            count = importantNotUrgentList.count
        } else if tableView == self.notImportantNotUrgentTableView {
            count = notImportantNotUrgentList.count
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
            
        } else if tableView == self.notImportantUrgentTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCellTableViewCell
            let task = notImportantUrgentList[indexPath.section]
            cell.task = task
            cell.setup()
            cell.delegate = self
            cell.backgroundColor = UIColor(rgb: 0xFF9900)
            return cell
            
        } else if tableView == self.importantNotUrgentTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCellTableViewCell
            let task = importantNotUrgentList[indexPath.section]
            cell.task = task
            cell.setup()
            cell.delegate = self
            cell.backgroundColor = UIColor(rgb: 0x2b78e4)
            return cell
            
        } else if tableView == self.notImportantNotUrgentTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCellTableViewCell
            let task = notImportantNotUrgentList[indexPath.section]
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
        } else if tableView == self.notImportantUrgentTableView {
            vc.task = notImportantUrgentList[selectedIndex]
        } else if tableView == self.importantNotUrgentTableView {
            vc.task = importantNotUrgentList[selectedIndex]
        } else if tableView == self.notImportantNotUrgentTableView {
            vc.task = notImportantNotUrgentList[selectedIndex]
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

    // Shows completed tasks tableview on click
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
        
        task.name = vc.nameTextField.text
        task.done = done
        task.urgency = vc.urgentSwitch.isOn
        task.importantness = vc.importantSwitch.isOn
        
        taskManager.saveContext()
        fetchAndRefreshAllTableViews()
    }
    
    // MARK: - TableView Delegate Functions
    
    // Remove/delete task
    func removeTask(task: Task) {
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
            return 0x5687d4
        } else {
            return 0xcccccc
        }
    }
    
    func fetchFromCoreData() {
        importantUrgentList = taskManager.fetch(done: false, urgency: true, importantness: true)
        notImportantUrgentList = taskManager.fetch(done: false, urgency: true, importantness: false)
        importantNotUrgentList = taskManager.fetch(done: false, urgency: false, importantness: true)
        notImportantNotUrgentList = taskManager.fetch(done: false, urgency: false, importantness: false)
        allDoneTasks = taskManager.fetch(done: true)
    }

    // Refresh all tableviews
    func fetchAndRefreshAllTableViews() {
        fetchFromCoreData()
        importantUrgentTableView.reloadData()
        notImportantUrgentTableView.reloadData()
        importantNotUrgentTableView.reloadData()
        notImportantNotUrgentTableView.reloadData()
        completedTasksTableView.reloadData()
    }
}
