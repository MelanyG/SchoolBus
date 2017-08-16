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
    
    @IBOutlet weak var loginTxtField: UITextField!
    @IBOutlet weak var passTxtField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var switcher: UISwitch!
    @IBOutlet weak var blurView: UIView!
    
    var stateMachine: StateMachine = StateMachine()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCachedData()
        
        if !NetworkManager.isConnectedToInternet() {
            presentAlerView(with: SBConstants.LoginConstants.InternetConnectionAbsence)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = ""
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func configureCachedData() {
        if let session = CacheManager.currentSession {
            loginTxtField.text = session.email
            passTxtField.text = session.password
        }
    }
    
    @IBAction func signInPressed(_ sender: UIButton) {
        self.blurView.isHidden = false
        switch stateMachine.currentState {
        case .Initial, .Invalid:
            if let session = CacheManager.currentSession {
                stateMachine.updateState(state: .Authorised)
                getAll()
                debugPrint("Current session: \(session.sessionId)")
            } else {
                if checkForValidInPutData() {
                    self.blurView.isHidden = false
                    guard let mail = loginTxtField.text, let pass = passTxtField.text else { return }
                    NetworkManager.loginUser(mail, password: pass) { [weak self] (result: DataResult<Session>, statusCode: Int) in
                        switch result {
                        case .success(let value):
                            debugPrint(value)
                            let er = value.error?.error ?? 0
                            switch er {
                            case DataStatusCode.WrongData.rawValue :
                                self?.presentAlerView(with: SBConstants.LoginConstants.WrongDataInserted)
                                self?.stateMachine.updateState(state: .Invalid)
                            case DataStatusCode.OK.rawValue:
                                if self?.switcher.isOn ?? false{
                                    value.email = mail
                                    value.password = pass
                                    CacheManager.currentSession = value
                                }
                                self?.stateMachine.updateState(state: .Authorised)
                                self?.getAll()
                            default: break
                            }
                        case .failure(let error):
                            switch statusCode {
                            case DataStatusCode.Unauthorized.rawValue:
                                self?.stateMachine.updateState(state: .Initial)
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
                
                NetworkManager.logoutUser(mail, password: pass, completion: {[weak self] (result: DataResult<Session>, statusCode: Int) in
                    switch result {
                    case .success(let value):
                        debugPrint(value)
                        self?.stateMachine.updateState(state: .Initial)
                        CacheManager.cleanAll()
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
    
    func presentNextViewController() {
        NavigationManager.checkNavigationDirection(from: self)
   }
    
    func presentForgotViewController() {
        
        let storyboard = UIStoryboard(name: SBConstants.Main, bundle: nil)
        if let forgotViewController = storyboard.instantiateViewController(withIdentifier: String(describing: CallCenterViewController.self)) as? CallCenterViewController {
            forgotViewController.heightOfTitle = 0.0
            navigationController?.setNavigationBarHidden(false, animated: true)
            title = SBConstants.LoginConstants.BackButtonTitle
            navigationController?.pushViewController(forgotViewController, animated: true)
        }
        
    }
    
    func getAll() {
        if !NetworkManager.isConnectedToInternet() {
            presentAlerView(with: SBConstants.LoginConstants.InternetConnectionAbsence)
        }
        let group = DispatchGroup()
        group.enter()
        for i in 0...SBConstants.numberOfDaysToLoad {
            let day = Date().addNoOfDays(noOfDays: i)
            Loader.loadRoutes(for: day, completion: { (result: DayRouts?, statusCode: Int) in
                if DatabaseManager.shared.items.count == SBConstants.numberOfDaysToLoad {
                    DatabaseManager.shared.items = DatabaseManager.shared.items.sorted { $0.date < $1.date }
                    group.leave()
                }
            })
        }
        group.notify(queue: DispatchQueue.main, execute: {
            [weak self] in
            self?.updateInterface()
            self?.presentNextViewController()
        })
    }
    
    func presentAlerView(with text: String) {
        DispatchQueue.main.async { [weak self] in
            let alertView = UIAlertController(title: "", message: text, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertView.addAction(action)
            self?.present(alertView, animated: true, completion: nil)
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

