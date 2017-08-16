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
    @IBOutlet weak var commonView: UIView!
    
    var heightOfTitle: CGFloat = 64.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CallCenterViewController.imageTapped(gesture:)))
        phoneButton.addGestureRecognizer(tapGesture)
    }
    
    func configure() {
//        title = SBConstants.LoginConstants.ForgotPassword
//        customNavigationHeight.constant = heightOfTitle
        
        if heightOfTitle == 0 {
            customBarTitle.text = ""
            phoneDescription.text = SBConstants.LoginConstants.CallCenter
        } else {
            self.commonView.backgroundColor = UIColor(red: 241.0/255.0, green: 241.0/255.0, blue: 245.0/255.0, alpha: 1)
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
