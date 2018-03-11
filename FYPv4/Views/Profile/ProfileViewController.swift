//
//  ProfileViewController.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-01-24.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, CanSwitchTabBarViewControllers {
    
    @IBOutlet weak var profilePicContainer: UIView!
    @IBOutlet weak var profileImageMask: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userDescription: UITextView!
    @IBOutlet weak var fitnessTypes: UILabel!
    
    let webservice: WebService
    let user: User
    
    init(user: User, webService: WebService) {
        self.user = user
        self.webservice = webService
        super.init(nibName: ProfileViewController.nibName, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureViews()
        let barButtonRight = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: .plain, target: self, action: #selector(handleLogout))
        barButtonRight.tintColor = .gray
        self.navigationItem.setRightBarButton(barButtonRight, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.configureUI(.regularWhite)
        self.title = "Profile"
    }
}

extension ProfileViewController {
    
    func configureViews() {
        profilePicContainer.layer.applySketchShadow(color: .black, alpha: 0.15, x: -2, y: 9, blur: 22, spread: 0)
        profilePicContainer.roundCorners(by: 20)
        profileImageMask.roundCorners(by: 20)
        nameLabel.text = user.fullName
        nameLabel.setFontTo(style: .title)
        fitnessTypes.setFontTo(style: .paragraph)
        userDescription.setFontTo(style: .paragraph)
        userDescription.text = user.description
        fitnessTypes.text = user.type
    }
    
    
    
    @objc func handleLogout() {
        UserDefaultsStore.delete(withKey: User.self)
        UserDefaultsStore.delete(withKey: Routine.self)
        self.switchTo(tabBarState: .noUser)
    }
    
    
}
