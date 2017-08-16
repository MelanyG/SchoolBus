//
//  ProfileViewController.swift
//  SchoolBus
//
//  Created by Melany Gulianovych on 7/16/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var userProfile: UserModel = UserModel()
    static var profileInfo = ProfileInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 4 : 1
//        return SBConstants.numberRowsInProfile
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let model = ProfileViewModel(with: userProfile, and: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProfileCell.self)) as! ProfileCell
//        cell.configure(with: model)
        
        switch indexPath {
        case [0,0]:
            cell.titleLabel.text = "Хуліо Кокаїнас"
            cell.detailedLabel.text = "Ім'я"
        case [0,1]:
            cell.titleLabel.text = "000-000-00-00"
            cell.detailedLabel.text = "Номер телефону"
        case [0,2]:
            cell.titleLabel.text = "blow_cocaine@gmail.com"
            cell.detailedLabel.text = "Email"
        case [0,3]:
            cell.titleLabel.text = "11 Серпня, 2017"
            cell.detailedLabel.text = "Закінчення підписки"
            cell.reminder.text = "за 12 днів"
        default:
            cell.titleLabel.text = ProfileViewController.profileInfo.compName
            cell.detailedLabel.text = ""
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 1 ? 25 : 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 1 ? "АДРЕСИ (1)" : ""
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
}
