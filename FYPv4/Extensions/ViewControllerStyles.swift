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
        if style.navBarWhite {
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
        }
    }
}

struct ViewControllerStyle {
    let title: String
    let tintColor: UIColor
    let backgroundColor: UIColor
    let navBarOpaque: Bool
    let navBarWhite: Bool
}

extension ViewControllerStyle {
    static var homeStyle: ViewControllerStyle {
        return ViewControllerStyle(title: "Feed", tintColor: .white, backgroundColor: .white, navBarOpaque: true, navBarWhite: true)
    }
    
    static var regularWhite: ViewControllerStyle {
        return ViewControllerStyle(title: "", tintColor: .white, backgroundColor: .white, navBarOpaque: true, navBarWhite: true)
    }
}
