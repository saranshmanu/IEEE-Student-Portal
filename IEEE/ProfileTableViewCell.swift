//
//  ProfileTableViewCell.swift
//  Final Login
//
//  Created by Saransh Mittal on 08/02/17.
//  Copyright © 2017 Saransh Mittal. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var Information: UILabel!
    @IBOutlet weak var InformationType: UILabel!
    @IBOutlet weak var Icon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
