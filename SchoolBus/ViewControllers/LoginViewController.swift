//
//  LoginViewController.swift
//  SchoolBus
//
//  Created by Melaniia Hulianovych on 5/29/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var idLable: UILabel!
    @IBOutlet weak var loginTxtField: UITextField!
    @IBOutlet weak var passTxtField: UITextField!
    @IBOutlet weak var linkTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLink()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureLink() {
        linkTextView.linkTextAttributes = [NSForegroundColorAttributeName: UIColor.init(colorLiteralRed: 51.0/255.0, green: 180.0/255.0, blue: 227.0/225.0, alpha: 1.0), NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue] as [String : Any]
    }
    
    @IBAction func signInPressed(_ sender: UIButton) {
        
        
    }
    
}

