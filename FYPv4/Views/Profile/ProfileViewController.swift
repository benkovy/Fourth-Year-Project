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
    var user: User
    
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
        let barButtonRight = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: .plain, target: self, action: #selector(handleUserMenu))
        self.navigationItem.setRightBarButton(barButtonRight, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.configureUI(.regularWhite)
        
    }
}

extension ProfileViewController {
    
    func configureViews() {
        profilePicContainer.layer.applySketchShadow(color: .black, alpha: 0.15, x: -2, y: 9, blur: 22, spread: 0)
        profilePicContainer.roundCorners(by: 15)
        if let img = user.image, let data = Data(base64Encoded: img), let image = UIImage(data: data) {
            profileImageView.image = image
        } else {
            profileImageView.image = UIImage(named: "t4")
        }
        profileImageView.contentMode = .scaleAspectFill
        profileImageMask.roundCorners(by: 15)
        nameLabel.text = user.fullName
        nameLabel.setFontTo(style: .title)
        fitnessTypes.setFontTo(style: .paragraph)
        userDescription.setFontTo(style: .paragraph)
        userDescription.text = user.description
        fitnessTypes.text = user.type
    }
    
    @objc func handleUserMenu() {
        let vc = ProfileMenuViewController(user: user)
        vc.didLogout = {
            UserDefaultsStore.delete(withKey: User.self)
            UserDefaultsStore.delete(withKey: Routine.self)
            self.switchTo(tabBarState: .noUser)
        }
        
        vc.didUpdateUser = {
            guard let user = UserDefaultsStore.retrieve(User.self) else {
                return
            }
            self.user = user
            self.configureViews()
        }
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
}
