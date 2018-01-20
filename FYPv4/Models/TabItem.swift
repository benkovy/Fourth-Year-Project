//
//  TabItem.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-01-18.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import Foundation
import UIKit

enum TabItem: String {
    case home
    case profile
    case workout
    
    var item: UITabBarItem {
        let item = UITabBarItem(title: nil, image: UIImage(named: self.rawValue), tag: tag)
        return item
    }
    
    var tag: Int {
        switch self {
        case .home: return 1
        case .profile: return 2
        case .workout: return 3
        }
    }
}
