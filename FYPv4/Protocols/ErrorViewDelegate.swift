//
//  ErrorViewDelegate.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-03-29.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import Foundation
import UIKit

protocol ErrorViewDelegate {
    var errorView: ErrorView? { get set }
    func setupErrorView()
}

extension ErrorViewDelegate where Self: UIViewController {
    func setupErrorView() {
        if errorView == nil { return }
        self.view.addSubview(errorView!)
    }
}
