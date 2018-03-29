//
//  UIViewControllerExtension.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-02-11.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import Foundation
import UIKit

extension ProfileViewController {
    func setUpForTabBarController() {
        self.view.backgroundColor = .white
        self.tabBarItem = TabItem.profile.item
        self.tabBarItem.imageInsets = TabItem.profile.insets
    }
}

extension HomeViewController {
    func setUpForTabBarController() {
        self.view.backgroundColor = .white
        self.tabBarItem = TabItem.home.item
        self.tabBarItem.imageInsets = TabItem.home.insets
    }
}

extension RoutineViewController {
    func setUpForTabBarController() {
        self.view.backgroundColor = .white
        self.tabBarItem = TabItem.benchpress.item
        self.tabBarItem.imageInsets = TabItem.benchpress.insets
        
    }
}

extension LoginViewController {
    func setUpForTabBarController() {
        self.view.backgroundColor = .white
        self.tabBarItem = TabItem.profile.item
        self.tabBarItem.imageInsets = TabItem.profile.insets
        self.navigationController?.navigationBar.isHidden = true
    }
}


extension HomeViewController {
    
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
}
