//
//  LoginViewController.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-01-18.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController {
    
    @IBOutlet weak var signSlider: UIView!
    @IBOutlet weak var signinButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var upperBackground: UIView!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var userInputView: UIView!
    @IBOutlet weak var emailView: PeakUITextField!
    @IBOutlet weak var passwordView: PeakUITextField!
    @IBOutlet weak var confirmPasswordView: PeakUITextField!
    @IBOutlet weak var pageTwo: UIView!
    @IBOutlet weak var firstnameView: PeakUITextField!
    @IBOutlet weak var lastnameView: PeakUITextField!
    @IBOutlet weak var dateofbirthView: PeakUITextField!
    @IBOutlet weak var letsGoButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    let datePicker = UIDatePicker()
    let webservice = WebService()
    var user = User()
    var emailBool = false
    var passBool = false
    var passConfBool = false
    var canSignUp: Bool { return emailBool && passBool && passConfBool }
    var canSignIn: Bool { return emailBool && passBool }
    var state = LoginViewState.create {
        didSet { setState() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDatePicker()
        startListening()
        emailView.textField.keyboardType = .emailAddress
        passwordView.textField.isSecureTextEntry = true
        confirmPasswordView.textField.isSecureTextEntry = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard(_:)))
        self.view.addGestureRecognizer(gesture)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        letsGoButton.isEnabled = false
        nextButton.isEnabled = false
        confirmPasswordView.textField.addTarget(self, action: #selector(handleChange), for: .editingChanged)
        setState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLayoutSubviews() {
        self.pageTwo.center.x += self.view.bounds.width
    }
    
    init() {
        super.init(nibName: LoginViewController.nibName, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func toggleSignIn(_ sender: UIButton) {
        switch sender.tag {
        case 0: state.changeState(.create)
        case 1: state.changeState(.login)
        default: print("Catch error")
        }
    }
    
    @IBAction func letsGoButtonPress(_ sender: UIButton) {
        switch state {
        case .create:
            UIView.animate(withDuration: 0.3, animations: {
                self.userInputView.center.x -= self.view.bounds.width
            })
            UIView.animate(withDuration: 0.3, delay: 0.1, options: [], animations: {
                self.pageTwo.center.x = self.view.center.x
            })
            user.email = emailView.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            user.password = passwordView.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        case .login:
            print("Login")
        }
    }
    
    @IBAction func nextButtonPress(_ sender: UIButton) {
        user.dateofbirth = dateofbirthView.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        user.firstname = firstnameView.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        user.lastname = lastnameView.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        createUser()
    }
    
    @objc func closeKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func createUser() {
        webservice.load(User.createUserRequest(user)) { (result) in
            guard let result = result else { return }
            switch result {
            case .error(let error): print("Error: \(error)")
            case .success(let user):
                if let _id = user.id {
                    self.user.id = _id
                }
                self.login(user.email, self.user.password ?? "")
            }
        }
    }
    
    func login(_ username: String, _ password: String) {
        webservice.load(Token.getToken(username, password)) { (result) in
            guard let result = result else { return }
            switch result {
            case .error(let error): print("Error: \(error)")
            case .success(let token):
                self.user.password = nil
                self.user.token = token
                self.prepareToLeaveLogin()
            }
        }
    }
    
    func prepareToLeaveLogin() {
        UserDefaultsStore.store(persistables: user)
        DispatchQueue.main.async {
            let webservice = WebService()
            let routine = RoutineViewController()
            routine.setUpForTabBarController()
            let profile = ProfileViewController()
            profile.setUpForTabBarController()
            let home = HomeViewController(webservice: webservice)
            home.setUpForTabBarController()
            let controllers = [routine, home, profile].map { UINavigationController(rootViewController: $0) }
            self.tabBarController?.setViewControllers(controllers, animated: true)
        }
    }
    
    func setState() {
        switch state {
        case .create:
            self.toggleLetsGoButton()
            UIView.animate(withDuration: 0.5, animations: {
                self.signSlider.center.x = (self.buttonStackView.center.x - self.buttonStackView.bounds.width/2) + self.signupButton.bounds.width/2
                self.confirmPasswordView.center.x = self.passwordView.center.x
            })
        case .login:
            confirmPasswordView.forceBackToNoText()
            passConfBool = false
            UIView.animate(withDuration: 0.5, animations: {
                self.signSlider.center.x = (self.buttonStackView.center.x + self.buttonStackView.bounds.width/2) - self.signinButton.bounds.width/2
                self.pageTwo.center.x = self.pageTwo.center.x + self.view.bounds.width
                self.userInputView.center.x = self.view.center.x
                self.confirmPasswordView.center.x -= self.view.bounds.width
            })
        }
    }
}
