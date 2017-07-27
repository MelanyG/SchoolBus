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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SBConstants.numberRowsInProfile
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = ProfileViewModel(with: userProfile, and: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProfileCell.self)) as! ProfileCell
        cell.configure(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SBConstants.heighStableRowsInSchedule
    }
}
