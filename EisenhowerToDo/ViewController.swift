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
    
    // Outlets for the four table views
    @IBOutlet weak var newTaskButton: UIButton!
    @IBOutlet weak var nImportantUrgentTableView: UITableView!
    @IBOutlet weak var importantUrgentTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        importantUrgentTableView.delegate = self
        importantUrgentTableView.dataSource = self
        nImportantUrgentTableView.delegate = self
        nImportantUrgentTableView.dataSource = self
        
        // Do any additional setup after loading the view, typically from a nib.

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
            //let found = tasks.filter{$0.importantness == false && $0.urgency == false}
            count = tasksTT.count
                }
        
        else if tableView == self.nImportantUrgentTableView {
            count = tasksFT.count
        }
        
        return count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        // register tableviewcells to cellreuseidentifier
        tableView.register(ImportantUrgentTableViewCell.self, forCellReuseIdentifier: "ImportantUrgentCell")
        tableView.register(NImportantUrgentTableViewCell.self, forCellReuseIdentifier: "NImportantUrgentCell")
        
        // for each tableview, load cells
        if tableView == self.importantUrgentTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImportantUrgentCell", for: indexPath) as! ImportantUrgentTableViewCell
            let task = tasksTT[indexPath.row]
            cell.task = task
            //print("\(task)")
        }
    
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NImportantUrgentCell", for: indexPath) as! NImportantUrgentTableViewCell
            let task = tasksFT[indexPath.row]
            cell.task = task
            //print("\(task)")

        }
        
        return cell
    }
    
    // receiving newtask to categorize
    @IBAction func createTaskSegue(_ segue: UIStoryboardSegue) {
        
        let vc = segue.source as? AddTaskViewController
        let createdTask = Task(name: (vc?.name.text!)!, urgency: (vc?.urgentSwitch.isOn)!, importantness: (vc?.importantSwitch.isOn)!, done: false)
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

    override func viewDidAppear(_ animated: Bool) {
        self.importantUrgentTableView?.reloadData()
                }
}

