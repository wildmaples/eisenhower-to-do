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

    // Outlets for the four table views
    @IBOutlet weak var newTaskButton: UIButton!
    @IBOutlet weak var NImportantUrgent: UITableView?
    @IBOutlet weak var ImportantUrgent: UrImTableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ImportantUrgent?.delegate = self
        ImportantUrgent?.dataSource = self
        NImportantUrgent?.delegate = self
        NImportantUrgent?.dataSource = self
        
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
        if tableView == self.ImportantUrgent {
            //let found = tasks.filter{$0.importantness == false && $0.urgency == false}
            count = tasksTT.count
                }
        
        else if tableView == self.NImportantUrgent {
            count = tasksFT.count
        }
        
        return count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell
        
        // register tableviewcells to cellreuseidentifier
        tableView.register(OneTableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.register(TwoTableViewCell.self, forCellReuseIdentifier: "Cell2")
        
        // for each tableview, load cells
        if tableView == self.ImportantUrgent {
            let quad1 = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            let task = tasksTT[indexPath.row]
            quad1.textLabel?.text = task.name
            cell = quad1
        }
            
        else {
            let quad2 = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath)
            let task = tasksFT[indexPath.row]
            quad2.textLabel?.text = task.name
            cell = quad2
        }
        
        return cell
    }
}

extension CGRect{
    init(_ x:CGFloat,_ y:CGFloat,_ width:CGFloat,_ height:CGFloat) {
        self.init(x:x,y:y,width:width,height:height)
    }
    
}
