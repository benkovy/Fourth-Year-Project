//
//  NibLoadableView.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-01-19.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import Foundation
import UIKit

protocol NibLoadableView: class {}

extension NibLoadableView where Self: UIViewController {
    static var nibName: String {
        return String(describing: self)
    }
}
