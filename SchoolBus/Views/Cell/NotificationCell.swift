//
//  NotificationCell.swift
//  SchoolBus
//
//  Created by Melany Gulianovych on 7/9/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(with model: NotificationViewModel) {
        titleLabel.text = model.title
        descriptionLabel.text = model.description
        timeLabel.text = model.time
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
