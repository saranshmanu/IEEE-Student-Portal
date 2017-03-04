//
//  UsersTableViewCell.swift
//  Final Login
//
//  Created by Saransh Mittal on 06/02/17.
//  Copyright © 2017 Saransh Mittal. All rights reserved.
//

import UIKit

class UsersTableViewCell: UITableViewCell {

    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var RegistrationNumberLabel: UILabel!
    @IBOutlet weak var ProfileImageLabel: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
