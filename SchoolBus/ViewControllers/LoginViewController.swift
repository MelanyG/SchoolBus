//
//  LoginViewController.swift
//  SchoolBus
//
//  Created by Melaniia Hulianovych on 5/29/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import Foundation
import UIKit

enum State {
    case Initial
    case Authorised
    case UnAuthorised
    case Invalid
}

struct StateMachine {
    
    private var state: State = .Initial
    
    var currentState: State {
        return state
    }
    
    mutating func updateState(state: State) {
        self.state = state
    }
}

class LoginViewController: UIViewController {
    
    @IBOutlet weak var idLable: UILabel!
    @IBOutlet weak var loginTxtField: UITextField!
    @IBOutlet weak var passTxtField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var switcher: UISwitch!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var rememberMe: UILabel!
    @IBOutlet weak var forgotPassword: UIButton!
    @IBOutlet weak var loginImage: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var incorrectPasswordLabel: UILabel!
    
    var stateMachine: StateMachine = StateMachine()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCachedData()
        
        /// Login and password text fields borders
        let loginBorder = CALayer()
        let passwordBorder = CALayer()
        let width = CGFloat(1)
        loginBorder.borderColor = UIColor.lightGray.cgColor
        passwordBorder.borderColor = UIColor.lightGray.cgColor
        
        loginBorder.frame = CGRect(x: 0, y: self.loginTxtField.frame.size.height - width, width: self.loginTxtField.frame.size.width, height: self.loginTxtField.frame.size.height)
        passwordBorder.frame = CGRect(x: 0, y: self.passTxtField.frame.size.height - width, width: self.passTxtField.frame.size.width, height: self.passTxtField.frame.size.height)
        loginBorder.borderWidth = width
        passwordBorder.borderWidth = width
        
        self.loginTxtField.layer.addSublayer(loginBorder)
        self.loginTxtField.layer.masksToBounds = true
        self.passTxtField.layer.addSublayer(passwordBorder)
        self.passTxtField.layer.masksToBounds = true
    
        if !NerworkManager.isConnectedToInternet() {
            presentAlerView(with: SBConstants.LoginConstants.InternetConnectionAbsence)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = ""
        navigationController?.setNavigationBarHidden(true, animated: false)
        self.loginButton.layer.cornerRadius = 15
    }
    
    func configureCachedData() {
        if let session = CacheManager.currentSession {
            loginTxtField.text = session.email
            passTxtField.text = session.password
        }
    }
    //    func configureLink() {
    //        linkTextView.linkTextAttributes = [NSForegroundColorAttributeName: UIColor.init(colorLiteralRed: 51.0/255.0, green: 180.0/255.0, blue: 227.0/225.0, alpha: 1.0), NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue] as [String : Any]
    //    }
    
    @IBAction func signInPressed(_ sender: UIButton) {
        
        /// Hide Login elements while signing in
        self.loginTxtField.isHidden = true
        self.passTxtField.isHidden = true
        self.signInButton.isHidden = true
        self.rememberMe.isHidden = true
        self.switcher.isHidden = true
        self.forgotPassword.isHidden = true
        
        self.blurView.isHidden = false
        self.loginImage.isHidden = false
        
        switch stateMachine.currentState {
        case .Initial, .Invalid:
            if let session = CacheManager.currentSession {
                stateMachine.updateState(state: .Authorised)
                //                updateInterface()
                getAllRoutes()
                MapManager.getRouteData()
                ProfileManager.getProfileData()
                MapManager.getSchoolBusPosition()
                debugPrint("Current session: \(session.sessionId)")
            } else {
                if checkForValidInPutData() {
                    self.blurView.isHidden = false
                    guard let mail = loginTxtField.text, let pass = passTxtField.text else { return }
                    NerworkManager.loginUser(mail, password: pass) { [weak self] (result: DataResult<Session>, statusCode: Int) in
                        switch result {
                        case .success(let value):
                            debugPrint(value)
                            let er = value.error?.error ?? 0
                            switch er {
                            case DataStatusCode.WrongData.rawValue :
                                self?.presentAlerView(with: SBConstants.LoginConstants.WrongDataInserted)
                                self?.stateMachine.updateState(state: .Invalid)
                            //                                self?.updateInterface()
                            case DataStatusCode.OK.rawValue:
                                if self?.switcher.isOn ?? false{
                                    value.email = mail
                                    value.password = pass
                                    CacheManager.currentSession = value
                                }
                                self?.stateMachine.updateState(state: .Authorised)
                                //                                self?.updateInterface()
                                self?.getAllRoutes()
                            default: break
                            }
                        case .failure(let error):
                            switch statusCode {
                            case DataStatusCode.Unauthorized.rawValue:
                                self?.stateMachine.updateState(state: .Initial)
                                //                                self?.updateInterface()
                                CacheManager.cleanAll()
                            default:
                                debugPrint(error)
                                break
                            }
                        }
                    }
                }
            }
        case .Authorised:
            if let mail = loginTxtField.text, let pass = passTxtField.text {
                
                NerworkManager.logoutUser(mail, password: pass, completion: {[weak self] (result: DataResult<Session>, statusCode: Int) in
                    switch result {
                    case .success(let value):
                        debugPrint(value)
                        self?.stateMachine.updateState(state: .Initial)
                        CacheManager.cleanAll()
                    //                        self?.updateInterface()
                    case .failure(let error):
                        debugPrint(error)
                    }
                })
            }
        default: break
        }
    }
    
    func updateInterface() {
        DispatchQueue.main.async { [weak self] in
            switch self?.stateMachine.currentState ?? .Initial {
            case .Initial, .UnAuthorised:
                self?.signInButton.setTitle(SBConstants.LoginConstants.UnAuthorisedorisedButtonTitle, for: UIControlState.normal)
                self?.loginTxtField.text = ""
                self?.passTxtField.text = ""
            case .Authorised:
                self?.signInButton.setTitle(SBConstants.LoginConstants.AuthorisedorisedButtonTitle, for: UIControlState.normal)
            case .Invalid:
                self?.passTxtField.text = ""
            }
        }
    }
    
    @IBAction func forgotPasswordPressed(_ sender: UIButton) {
        
        presentForgotViewController()
    }
    
    func presentDetailViewController() {
        
        let storyboard = UIStoryboard(name: SBConstants.Main, bundle: nil)
        if let tabBarController = storyboard.instantiateViewController(withIdentifier:String(describing: UITabBarController.self)) as? UITabBarController {
            self.blurView.isHidden = true
            navigationController?.pushViewController(tabBarController, animated: true)
        }
        
    }
    
    func presentForgotViewController() {
        
        let storyboard = UIStoryboard(name: SBConstants.Main, bundle: nil)
        if let forgotViewController = storyboard.instantiateViewController(withIdentifier: String(describing: CallCenterViewController.self)) as? CallCenterViewController {
            forgotViewController.heightOfTitle = 0.0
            navigationController?.setNavigationBarHidden(false, animated: true)
            title = SBConstants.LoginConstants.BackButtonTitle
            navigationController?.navigationBar.tintColor = UIColor.orange
            
            navigationController?.pushViewController(forgotViewController, animated: true)
        }
        
    }
    
    func getAllRoutes() {
        if !NerworkManager.isConnectedToInternet() {
            presentAlerView(with: SBConstants.LoginConstants.InternetConnectionAbsence)
        }
        let group = DispatchGroup()
        group.enter()
        for i in 1...SBConstants.numberOfDaysToLoad {
            let day = Date().addNoOfDays(noOfDays: i)
            NerworkManager.getRoutesByDate(date: day.shortDate) {
                (result: DataResult<DayRouts>, statusCode: Int) in
                
                switch result {
                case .success(let value):
                    value.date = day
                    value.connectRoutsWithPoints()
                    debugPrint(value)
                    DatabaseManager.shared.addItem(dayItem: value)
                    if DatabaseManager.shared.items.count == SBConstants.numberOfDaysToLoad {
                        DatabaseManager.shared.items = DatabaseManager.shared.items.sorted { $0.date < $1.date }
                        group.leave()
                    }
                    
                case .failure(let error):
                    switch statusCode {
                    case DataStatusCode.Unauthorized.rawValue:
                        debugPrint(error)
                        
                    default:
                        debugPrint(error)
                        break
                    }
                }
                
            }
        }
        group.notify(queue: DispatchQueue.main, execute: {
            [weak self] in
            self?.updateInterface()
            self?.presentDetailViewController()
        })
    }
    
    func presentAlerView(with text: String) {
        DispatchQueue.main.async { [weak self] in
            let alertView = UIAlertController(title: "", message: text, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertView.addAction(action)
            self?.present(alertView, animated: true, completion: nil)
        
            /// Show login elements
            self?.passTxtField.textColor = text == SBConstants.LoginConstants.WrongDataInserted ? UIColor.red : UIColor.black
            self?.passTxtField.layer.sublayers?.map { $0.borderColor = text == SBConstants.LoginConstants.WrongDataInserted ? UIColor.red.cgColor : UIColor.lightGray.cgColor }
            self?.incorrectPasswordLabel.text = text == SBConstants.LoginConstants.WrongDataInserted ? "Ви ввели невірний пароль" : ""
            self?.loginTxtField.isHidden = false
            self?.passTxtField.isHidden = false
            self?.signInButton.isHidden = false
            self?.rememberMe.isHidden = false
            self?.switcher.isHidden = false
            self?.forgotPassword.isHidden = false
            self?.blurView.isHidden = true
        }
    }
    
    private func checkForValidInPutData() -> Bool {
        if loginTxtField.text == "" {
            presentAlerView(with: SBConstants.LoginConstants.EMailDataEmpty)
            self.blurView.isHidden = true
            return false
        }
        if passTxtField.text == "" {
            presentAlerView(with: SBConstants.LoginConstants.PasswordDataEmpty)
            self.blurView.isHidden = true
            return false
        }
        return true
    }
    
}
