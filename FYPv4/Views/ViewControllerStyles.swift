//
//  ViewControllerStyles.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-03-06.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func configureUI(_ style: ViewControllerStyle) {
        self.title = style.title
        self.view.backgroundColor = style.backgroundColor
        self.navigationController?.navigationBar.barTintColor = style.tintColor
        self.navigationController?.navigationBar.isOpaque = style.navBarOpaque
        self.tabBarItem.title = ""
    }
}

struct ViewControllerStyle {
    let title: String
    let tintColor: UIColor
    let backgroundColor: UIColor
    let navBarOpaque: Bool
}

extension ViewControllerStyle {
    
    static var homeStyle: ViewControllerStyle {
        return ViewControllerStyle(title: "Feed", tintColor: .clear, backgroundColor: .white, navBarOpaque: false)
    }
}
