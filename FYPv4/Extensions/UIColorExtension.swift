//
//  UIColorExtension.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-01-25.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    static var peakBlue: UIColor {
        return UIColor(red:0.00, green:0.51, blue:0.99, alpha:1.00)
    }
    
    static var lightGray: UIColor {
        return UIColor(white: 0, alpha: 0.5)
    }
}

    
extension UIView {
    func roundCorners(by: CGFloat) {
        self.layer.cornerRadius = by
    }
}

extension CALayer {
    
    func setCircular() {
        
    }
    
    func applySketchShadow( color: UIColor = .black, alpha: Float = 0.5, x: CGFloat = 0, y: CGFloat = 2, blur: CGFloat = 4, spread: CGFloat = 0)
    {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}
