//
//  NavigationManager.swift
//  SchoolBus
//
//  Created by Melany Gulianovych on 8/6/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import Foundation
import UIKit

class NavigationManager {

    static func checkMavigationDirection(from controller: LoginViewController) -> String {
        if DatabaseManager.shared.items.count > 0 {
            if DatabaseManager.shared.items.first?.date == Date() {
            
            }
        }
        return Hosts.Development.rawValue
    }

    static func presentDetailViewController(from controller: LoginViewController) {
        
        let storyboard = UIStoryboard(name: SBConstants.Main, bundle: nil)
        if let tabBarController = storyboard.instantiateViewController(withIdentifier:String(describing: UITabBarController.self)) as? UITabBarController {
            controller.blurView.isHidden = true
            controller.navigationController?.pushViewController(tabBarController, animated: true)
        }
        
    }
}
