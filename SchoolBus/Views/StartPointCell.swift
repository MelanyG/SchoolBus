//
//  StartPointCell.swift
//  SchoolBus
//
//  Created by Melany Gulianovych on 6/27/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import UIKit

class TimePointCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    
    func configure(with time: Date) {
        
        timeLabel.text = Date.getTime(time)
        
    }

}
