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

class Distancecell: UITableViewCell {
    @IBOutlet weak var distanceLabel: UILabel!
    
    func configure(with data: Int) {
        distanceLabel.text = "\(data)"
    }
}

class PointCell: UITableViewCell {
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var stopLabel: UILabel!
    @IBOutlet weak var distanceTimeLabel: UILabel!
    
    func configure(with address: String, position inRout: Int, arrival time: Date) {
        addressLabel.text = address
        stopLabel.text = "Stop \(inRout) - \(Date.getTime(time))"
    }
}
