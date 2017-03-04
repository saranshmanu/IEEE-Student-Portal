//
//  WorkProjectTableViewCell.swift
//  Final Login
//
//  Created by Saransh Mittal on 07/02/17.
//  Copyright © 2017 Saransh Mittal. All rights reserved.
//

import UIKit

class WorkProjectTableViewCell: UITableViewCell {

    @IBOutlet weak var StatusLabel: UILabel!
    @IBOutlet weak var WorkDescriptionLabel: UILabel!
    @IBOutlet weak var WorkTitleLabel: UILabel!
    @IBOutlet weak var AllotedDate: UILabel!
    @IBOutlet weak var DeadlineDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
