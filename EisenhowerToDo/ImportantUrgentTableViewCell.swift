//
//  TTTableViewCell.swift
//  EisenhowerToDo
//
//  Created by Maple Ong on 5/30/18.
//  Copyright © 2018 MO. All rights reserved.
//

import UIKit

class ImportantUrgentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var taskLabel: UILabel!
    
    var task : Task! {
        didSet {
            guard (task) != nil else { return }
            print("activated!")

            print("task.name : \(task.name)")
        
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
