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
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var marker: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(with model: NotificationViewModel) {
        titleLabel.text = model.title
        descriptionLabel.text = model.description
        timeLabel.text = model.time
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
