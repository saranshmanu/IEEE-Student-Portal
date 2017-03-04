//
//  ProjectInformationTableViewCell.swift
//  IEEE Students Portal
//
//  Created by Saransh Mittal on 14/02/17.
//  Copyright © 2017 Saransh Mittal. All rights reserved.
//

import UIKit

class ProjectInformationTableViewCell: UITableViewCell {

    @IBOutlet weak var Value: UILabel!
    @IBOutlet weak var Label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
