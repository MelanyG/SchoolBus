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
    
    static func checkNavigationDirection(from controller: LoginViewController) {
        if DatabaseManager.shared.items.count > 0 && DatabaseManager.shared.items[0].routs?.count ?? 0 > 0 {
            for route in DatabaseManager.shared.items[0].routs! {
                if Date.isDate(date: Date(), between: route.beginTime, and: route.endTime) {
                    NavigationManager.presentDetailViewController(from: controller, with: route)
                    return
                }
            }
        }
        NavigationManager.presentScheduleViewController(from: controller)
    }
    
    static func presentDetailViewController(from controller: LoginViewController, with route: RouteModel) {
        
        let storyboard = UIStoryboard(name: SBConstants.Main, bundle: nil)
        if let tabBarController = storyboard.instantiateViewController(withIdentifier:String(describing: UITabBarController.self)) as? UITabBarController {
            controller.blurView.isHidden = true
            (tabBarController.viewControllers?[0] as! DetailViewController).infoViewController.currentRoute = route
            controller.navigationController?.pushViewController(tabBarController, animated: true)
        }
    }
    
    static func presentScheduleViewController(from controller: LoginViewController) {
        let storyboard = UIStoryboard(name: SBConstants.Main, bundle: nil)
        if let tabBarController = storyboard.instantiateViewController(withIdentifier:String(describing: UITabBarController.self)) as? UITabBarController {
            tabBarController.selectedIndex = 1
            controller.blurView.isHidden = true
            controller.navigationController?.pushViewController(tabBarController, animated: true)
        }
    }
}
