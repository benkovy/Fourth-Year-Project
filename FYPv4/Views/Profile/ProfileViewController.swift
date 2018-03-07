//
//  ProfileViewController.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-01-24.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let barButtonRight = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        self.navigationItem.setRightBarButton(barButtonRight, animated: true)
    }
}

extension ProfileViewController {
    @objc func handleLogout() {
        UserDefaultsStore.delete(withKey: User.self)
    }
}
