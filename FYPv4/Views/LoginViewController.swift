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
    @IBOutlet weak var loginButton: UIButton!
    
    let database = Database()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    init() {
        super.init(nibName: LoginViewController.nibName, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func login(_ sender: UIButton) {
        let usernamePassword = UsernamePassword(username: username.text ?? "", password: password.text ?? "")
        authenticate(usernamePassword)
    }
    
    func authenticate(_ usernamePassword: UsernamePassword) {
        
    }
}

