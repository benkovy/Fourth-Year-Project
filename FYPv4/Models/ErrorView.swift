//
//  ErrorView.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-03-29.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import UIKit

class ErrorView: UIView {
    
    var errorLabel = UILabel()
    var inUse = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
        addSubview(errorLabel)
        errorLabel.frame = CGRect(x: 16, y: 0, width: self.frame.width, height: self.frame.height)
        errorLabel.setFontTo(style: .errorLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ErrorView {
    func callError(withTitle title: String, andColor color: UIColor) {
        if !inUse {
            self.backgroundColor = color
            self.errorLabel.text = title
            self.inUse = true
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
            }, completion: { finished in
                self.hideError()
                self.inUse = false
            })
        } else {
            UIView.animate(withDuration: 0.3, delay: 0.7, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.inUse = true
                self.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
            }, completion: { finished in
                self.hideError()
                self.inUse = false
            })
        }
    }
    
    func hideError() {
        UIView.animate(withDuration: 0.3, delay: 1.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.frame = CGRect(x: 0, y: -self.frame.height, width: self.frame.width, height: self.frame.height)
        }, completion: nil)
    }
}
