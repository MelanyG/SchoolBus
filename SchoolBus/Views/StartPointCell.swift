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
    
    func configure(with model: DataRepresentative, start: Bool = true) {
        if start {
            timeLabel.text = model.startTime
        }
        timeLabel.text = model.endTime
    }
    
}

class Distancecell: UITableViewCell {
    @IBOutlet weak var distanceLabel: UILabel!
    
    func configure(with model: DataRepresentative, distance: Bool = true) {
        if distance {
            distanceLabel.text = model.distance
        }
        distanceLabel.text = model.duration
    }
}

class PointCell: UITableViewCell {
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var stopLabel: UILabel!
    @IBOutlet weak var distanceTimeLabel: UILabel!
    
    func configure(with model: DataRepresentative) {
        addressLabel.text = model.pointAddress
        stopLabel.text = model.pointPosition
        distanceTimeLabel.text = model.pointDistanceAndTime
    }
}
