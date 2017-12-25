//
//  CustomTextField.swift
//  IEEE
//
//  Created by Saransh Mittal on 24/03/17.
//  Copyright © 2017 Saransh Mittal. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override func awakeFromNib() {
        attributedPlaceholder = NSAttributedString(string: placeholder!, attributes: [NSForegroundColorAttributeName: UIColor(white: 1.0,alpha:0.75)])
    }
    
}
