//
//  ViewConfigurable.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-03-05.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import Foundation
import UIKit

protocol ViewConfigurable {
    func configureView()
}

protocol ViewConfigurableDelegate: class {
    var view: ViewConfigurable { get set }    
}
