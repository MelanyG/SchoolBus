//
//  ProfileCell.swift
//  SchoolBus
//
//  Created by Melany Gulianovych on 7/16/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {
    
    @IBOutlet weak var detailedLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var reminder: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configure(with model: ProfileRepresentative) {
        titleLabel.text = model.profileData.title
        detailedLabel.text = model.profileData.name
    }
}
