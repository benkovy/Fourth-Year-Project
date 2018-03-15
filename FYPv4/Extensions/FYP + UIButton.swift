//
//  FYP + UIButton.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-03-08.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import Foundation
import UIKit

enum ButtonStyle {
    case primary
    case secondary
}

extension UIButton {
    static func makeButton(ofStyle style: ButtonStyle, withTitle title: String) -> UIButton {
        switch style {
        case .secondary:
            let view = UIButton(type: .custom)
            if let font = UIFont(name: "HelveticaNeue-Light", size: 22) {
                view.setAttributedTitle(NSAttributedString(string: title, attributes: [.font: font, .foregroundColor: UIColor.white]), for: .normal)
            }
            view.setTitleColor(.white, for: .normal)
            view.setBackgroundImage(#imageLiteral(resourceName: "buttonGrayWide"), for: .normal)
            return view
            
        case .primary:
            let view = UIButton(type: .custom)
            if let font = UIFont(name: "HelveticaNeue-Light", size: 22) {
                view.setAttributedTitle(NSAttributedString(string: title, attributes: [.font: font, .foregroundColor: UIColor.white]), for: .normal)
            }
            view.setTitleColor(.white, for: .normal)
            view.setBackgroundImage(#imageLiteral(resourceName: "buttonGrayWide"), for: .normal)
            return view
        }
    }
    
    func styleButtonFYP(withTitle: String) {
        self.backgroundColor = .fypGray
//        self.addTarget(self, action: #selector(buttonTouched(_:)), for: .touchUpInside)
        self.layer.cornerRadius = 12
        self.contentEdgeInsets = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
        if let font = UIFont(name: "HelveticaNeue-Light", size: 22) {
            self.setAttributedTitle(NSAttributedString(string: withTitle, attributes: [.font: font, .foregroundColor: UIColor.white]), for: .normal)
        }
    }
    
    func styleSmallButtonFYP(withTitle: String) {
        self.backgroundColor = .fypGray
        self.layer.cornerRadius = 4
        self.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        if let font = UIFont(name: "HelveticaNeue-Light", size: 14) {
            self.setAttributedTitle(NSAttributedString(string: withTitle, attributes: [.font: font, .foregroundColor: UIColor.white]), for: .normal)
        }
    }
    
    @objc func buttonTouched(_ sender: UIButton) {
        UIButton.animate(withDuration: 0.2, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.975, y: 0.96)
        }, completion: { finish in
            UIButton.animate(withDuration: 0.2, animations: {
                sender.transform = CGAffineTransform.identity
            })
        })
    }
}
