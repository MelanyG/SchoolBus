//
//  NotificationViewController.swift
//  SchoolBus
//
//  Created by Melany Gulianovych on 7/9/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension NotificationViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let model = NotificationViewModel()
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: NotificationCell.self)) as! NotificationCell
        cell.marker.image = indexPath.first == 0 ? #imageLiteral(resourceName: "notificationMarker") : UIImage()
//        cell.configure(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: NotificationCell.self)) as! NotificationCell
        cell.marker.image = section == 0 ? #imageLiteral(resourceName: "notificationMarker") : UIImage()
        return section == 0 ? SBConstants.NotificationConstants.UnReadMessage : SBConstants.NotificationConstants.ReadMessage
    }
    
}
