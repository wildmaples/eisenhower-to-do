//
//  FTTableViewCell.swift
//  EisenhowerToDo
//
//  Created by Maple Ong on 5/30/18.
//  Copyright © 2018 MO. All rights reserved.
//

import UIKit

class NImportantUrgentTableViewCell: UITableViewCell {

    @IBOutlet weak var FTTaskLabel: UILabel!
    
    var task : Task! {
        didSet {
            guard let task = task else { return }
            FTTaskLabel.text = task.name
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
