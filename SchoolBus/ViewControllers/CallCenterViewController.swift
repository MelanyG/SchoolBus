//
//  CallCenterViewController.swift
//  SchoolBus
//
//  Created by Melany Gulianovych on 7/9/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import UIKit

class CallCenterViewController: UIViewController {

    @IBOutlet weak var customNavigationHeight: NSLayoutConstraint!
    @IBOutlet weak var phoneButton: UIImageView!
    @IBOutlet weak var phoneDescription: UILabel!
    @IBOutlet weak var customBarTitle: UILabel!
    var heightOfTitle: CGFloat = 64.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CallCenterViewController.imageTapped(gesture:)))
        phoneButton.addGestureRecognizer(tapGesture)
    }
    
    func configure() {
        title = SBConstants.LoginConstants.ForgotPassword
        customNavigationHeight.constant = heightOfTitle
        if heightOfTitle == 0 {
            customBarTitle.text = ""
            phoneDescription.text = SBConstants.LoginConstants.CallCenter
        }
    }
    
    func imageTapped(gesture: UIGestureRecognizer) {
        if (gesture.view as? UIImageView) != nil {
            if let url = URL(string: "tel://\(SBConstants.callCenterNumber)"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
            
        }
    }
}
