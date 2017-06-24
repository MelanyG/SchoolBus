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

fileprivate struct Constants {
    static let AuthorisedorisedButtonTitle = "Successfully signed. Click for change."
    static let UnAuthorisedorisedButtonTitle = "Sign in."
    static let InternetConnectionAbsence = "No internet connection. Try again later."
    static let EMailDataEmpty = "Please insert email."
    static let PasswordDataEmpty = "Please insert password."
    static let WrongDataInserted = "Error in Connection. Mismatch between login and password. Please Try again."
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
    @IBOutlet weak var linkTextView: UITextView!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var switcher: UISwitch!
    
    var stateMachine: StateMachine = StateMachine()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLink()
        if !NerworkManager.isConnectedToInternet() {
            presentAlerView(with: Constants.InternetConnectionAbsence)
        }
    }
    
    func configureLink() {
        linkTextView.linkTextAttributes = [NSForegroundColorAttributeName: UIColor.init(colorLiteralRed: 51.0/255.0, green: 180.0/255.0, blue: 227.0/225.0, alpha: 1.0), NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue] as [String : Any]
    }
    
    @IBAction func signInPressed(_ sender: UIButton) {
        
        switch stateMachine.currentState {
        case .Initial, .Invalid:
            if let session = CacheManager.currentSession {
                stateMachine.updateState(state: .Authorised)
                updateInterface()
                getAllRoutes()
                debugPrint("Current session: \(session.sessionId)")
            } else {
                if checkForValidInPutData() {
                    guard let mail = loginTxtField.text, let pass = passTxtField.text else { return }
                    NerworkManager.loginUser(mail, password: pass) { [unowned self] (result: DataResult<Session>, statusCode: Int) in
                        switch result {
                        case .success(let value):
                            debugPrint(value)
                            let er = value.error?.error ?? 0
                            switch er {
                            case DataStatusCode.WrongData.rawValue :
                                self.presentAlerView(with: Constants.WrongDataInserted)
                                self.stateMachine.updateState(state: .Invalid)
                                self.updateInterface()
                            case DataStatusCode.OK.rawValue:
                                if self.switcher.isOn {
                                    value.email = mail
                                    value.password = pass
                                    CacheManager.currentSession = value
                                }
                                self.stateMachine.updateState(state: .Authorised)
                                self.updateInterface()
                                self.getAllRoutes()
                            default: break
                            }
                        case .failure(let error):
                            switch statusCode {
                            case DataStatusCode.Unauthorized.rawValue:
                                self.stateMachine.updateState(state: .Initial)
                                self.updateInterface()
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
                
                NerworkManager.logoutUser(mail, password: pass, completion: {[unowned self] (result: DataResult<Session>, statusCode: Int) in
                    switch result {
                    case .success(let value):
                        debugPrint(value)
                        self.stateMachine.updateState(state: .Initial)
                        CacheManager.cleanAll()
                        self.updateInterface()
                    case .failure(let error):
                        debugPrint(error)
                    }
                })
            }
        default: break
        }
    }
    
    func updateInterface() {
        DispatchQueue.main.async { [unowned self] in
            switch self.stateMachine.currentState {
            case .Initial, .UnAuthorised:
                self.signInButton.setTitle(Constants.UnAuthorisedorisedButtonTitle, for: UIControlState.normal)
                self.loginTxtField.text = ""
                self.passTxtField.text = ""
            case .Authorised:
                self.signInButton.setTitle(Constants.AuthorisedorisedButtonTitle, for: UIControlState.normal)
            case .Invalid:
                self.passTxtField.text = ""
            }
        }
    }
    
    func presentDetailViewController() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarViewController") as? UITabBarController {
            
            navigationController?.pushViewController(tabBarController, animated: true)
        }
        
    }
    
    func getAllRoutes() {
        if !NerworkManager.isConnectedToInternet() {
            presentAlerView(with: Constants.InternetConnectionAbsence)
        }
        let group = DispatchGroup()
        group.enter()
        for i in 1...5 {
            let day = Date().addNoOfDays(noOfDays: i)
            NerworkManager.getRoutesByDate(date: day.shortDate) {
                (result: DataResult<DayRouts>, statusCode: Int) in
                
                switch result {
                case .success(let value):
                    value.date = day
                    value.connectRoutsWithPoints()
                    debugPrint(value)
                    DatabaseManager.shared.addItem(dayItem: value)
                    if DatabaseManager.shared.items.count == 5 {
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
            [unowned self] in
            self.presentDetailViewController()
        })
    }
    
    func presentAlerView(with text: String) {
        DispatchQueue.main.async { [unowned self] in
            let alertView = UIAlertController(title: "", message: text, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertView.addAction(action)
            self.present(alertView, animated: true, completion: nil)
        }
    }
    
    private func checkForValidInPutData() -> Bool {
        if loginTxtField.text == "" {
            presentAlerView(with: Constants.EMailDataEmpty)
            return false
        }
        if passTxtField.text == "" {
            presentAlerView(with: Constants.PasswordDataEmpty)
            return false
        }
        return true
    }
}

