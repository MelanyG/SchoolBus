//
//  DetailViewController.swift
//  SchoolBus
//
//  Created by Melany Gulianovych on 6/4/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    private lazy var infoViewController: InfoViewController = {

        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "InfoViewController") as! InfoViewController
        self.add(asChildViewController: viewController)
        return viewController
    }()
    
    private lazy var mapViewController: MapViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        self.add(asChildViewController: viewController)
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
//        segmentedControl.selectedSegmentIndex = 0
    }
    
    @IBAction func changedSegmentedAction(_ sender: Any) {
        updateView()
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        addChildViewController(viewController)
        containerView.addSubview(viewController.view)
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParentViewController: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        viewController.willMove(toParentViewController: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }
    
    private func updateView() {
        if segmentedControl.selectedSegmentIndex == 0 {
            remove(asChildViewController: mapViewController)
            add(asChildViewController: infoViewController)
        } else {
            remove(asChildViewController: infoViewController)
            add(asChildViewController: mapViewController)
        }
    }
}

class DetailNavigationViewController: UINavigationController {
    
}

class LoginNavigationViewController: UINavigationController {
    
}
