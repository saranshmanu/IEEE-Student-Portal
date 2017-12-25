//
//  CalenderTableViewCell.swift
//  IEEE
//
//  Created by Saransh Mittal on 28/02/17.
//  Copyright © 2017 Saransh Mittal. All rights reserved.
//

import UIKit

class CalenderTableViewCell: UITableViewCell {

    @IBOutlet weak var EventDescription: UILabel!
    @IBOutlet weak var EventTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
