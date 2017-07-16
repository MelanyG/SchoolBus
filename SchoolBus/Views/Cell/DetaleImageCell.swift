//
//  DetaleImageCell.swift
//  SchoolBus
//
//  Created by Melany Gulianovych on 7/16/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import UIKit

class DetaleImageCell: UITableViewCell {

    @IBOutlet weak var chileLocation: UILabel!
    @IBOutlet weak var childName: UILabel!
    @IBOutlet weak var childPhoto: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with model: DataRepresentative) {
        childPhoto.image = model.childPicture
        childName.text = model.fullName
        chileLocation.text = model.pointAddress
    }

}

class FrameCell: UITableViewCell {
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var describingImage: UIImageView!
    
    func configure(with model: DataRepresentative) {
        describingImage.image = model.childPicture
        pointLabel.text = model.edgePoints.title
        descriptionLabel.text = model.edgePoints.description
        timeLabel.text = model.startTime
    }
}

class DetailCell: UITableViewCell {
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var imagePoint: UIImageView!
    
}
