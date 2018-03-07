//
//  UIViewControllerExtension.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-02-11.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import Foundation

extension ProfileViewController {
    func setUpForTabBarController() {
        self.view.backgroundColor = .black
        self.tabBarItem = TabItem.profile.item
        self.tabBarItem.imageInsets = TabItem.profile.insets
    }
    
    func setupNavigationBarStyle() {
        
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
        self.tabBarItem = TabItem.workout.item
        self.tabBarItem.imageInsets = TabItem.workout.insets
        
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
