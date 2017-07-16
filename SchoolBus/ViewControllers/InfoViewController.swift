//
//  InfoViewController.swift
//  SchoolBus
//
//  Created by Melany Gulianovych on 7/16/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

    var currentRoute: RouteModel? = DatabaseManager.shared.items[0].routs?[0]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

extension InfoViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int{
       return SBConstants.stableRowsInSchedule
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 2
        } else if section == 2 {
            return 3
        } else if section == 3 {
            return currentRoute?.qtyOfPoints ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model: DataRepresentative = RouteViewModel(with: currentRoute, and: indexPath.row)
               if indexPath.row == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetaleImageCell") as! DetaleImageCell
        cell.configure(with: model)
        return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SBConstants.heighStableRowsInSchedule
    }
}
