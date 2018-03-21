//
//  FYP + Fonts.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-03-07.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import Foundation
import UIKit

enum FontStyle {
    case title
    case subtitle
    case paragraph
    case cellParagraph
    case name
    case inputLabel
}


extension UILabel {
    func setFontTo(style: FontStyle) {
        switch style {
        case .name:
            self.font = UIFont(name: "HelveticaNeue-Light", size: 13)
            self.textColor = UIColor.lightGray
        case .cellParagraph:
            self.font = UIFont(name: "HelveticaNeue-Light", size: 12)
        case .title:
            self.font = UIFont(name: "HelveticaNeue-Light", size: 24)
            self.textColor = UIColor.lightGray
        case .paragraph:
            self.font = UIFont(name: "HelveticaNeue-Light", size: 15)
            self.textColor = UIColor.lightGray
        case .subtitle:
            self.font = UIFont(name: "HelveticaNeue-UltraLight", size: 20)
        case .inputLabel:
            self.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        }
    }
}

extension UITextView {
    func setFontTo(style: FontStyle) {
        switch style {
        case .name:
            self.font = UIFont(name: "HelveticaNeue-Light", size: 13)
            self.textColor = UIColor.lightGray
        case .cellParagraph:
            self.font = UIFont(name: "HelveticaNeue-Light", size: 12)
            self.textColor = UIColor.lightGray
        case .title:
            self.font = UIFont(name: "HelveticaNeue-Light", size: 24)
            self.textColor = UIColor.lightGray
        case .paragraph:
            self.font = UIFont(name: "HelveticaNeue-Light", size: 15)
            self.textColor = UIColor.lightGray
        case .subtitle:
            self.font = UIFont(name: "HelveticaNeue-UltraLight", size: 20)
        case .inputLabel:
            self.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        }
    }
}
