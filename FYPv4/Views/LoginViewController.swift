//
//  LoginViewController.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-01-18.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController, NibLoadableView {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var rePassword: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var toggleCreateLogin: UIButton!
    
    let webservice = WebService()
    var state = LoginViewState.login {
        didSet { setState() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setState()
    }
    
    init() {
        super.init(nibName: LoginViewController.nibName, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func toggle(_ sender: UIButton) { state.changeState() }
    
    @IBAction func login(_ sender: UIButton) {
        switch state {
        case .login:
            handleLogin(UsernamePassword(username: username.text ?? "", password: password.text ?? ""))
        case .create:
            if rePassword.text == password.text {
                handleCreate(UsernamePassword(username: username.text ?? "", password: password.text ?? ""))
            }
        }
    }
    
    func handleLogin(_ auth: UsernamePassword) {
        
    }
    
    func handleCreate(_ auth: UsernamePassword) {
        // we need to create a user here
        // We have - email & password
        // We need - firstname, lastname, description, dob, type
        
//        webservice.load(, completion: <#T##(Result<A>?) -> ()#>)
    }
    
    func handleAuthSuccess() {
        if let window = UIApplication.shared.delegate?.window ?? nil {
            window.rootViewController = (UIApplication.shared.delegate as! AppDelegate).mainViewController
        }
    }
    
    func setState() {
        loginButton.setTitle(state.authButton, for: .normal)
        toggleCreateLogin.setTitle(state.toggleButton, for: .normal)
        rePassword.isHidden = state.isHidden
    }
}
