//
//  CanSwitchTabBarViewControllers.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-03-08.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import Foundation
import UIKit

enum TabBarState {
    case noUser
    case user(User)
}

protocol CanSwitchTabBarViewControllers {
    func switchTo(tabBarState state: TabBarState)
}

extension CanSwitchTabBarViewControllers where Self: UIViewController {
    func switchTo(tabBarState state: TabBarState) {
        switch state {
        case .noUser:
            let webservice = WebService()
            let routine = RoutineViewController()
            routine.setUpForTabBarController()
            let auth = LoginViewController()
            auth.setUpForTabBarController()
            let home = HomeViewController(webservice: webservice)
            home.setUpForTabBarController()
            let controllers = [routine, home, auth].map { UINavigationController(rootViewController: $0) }
            self.tabBarController?.setViewControllers(controllers, animated: true)
        case .user(let user):
            let webservice = WebService()
            let routine = RoutineViewController()
            routine.setUpForTabBarController()
            let profile = ProfileViewController(user: user, webService: WebService())
            profile.setUpForTabBarController()
            let home = HomeViewController(webservice: webservice)
            home.setUpForTabBarController()
            let controllers = [routine, home, profile].map { UINavigationController(rootViewController: $0) }
            self.tabBarController?.setViewControllers(controllers, animated: true)
        }
    }
}
