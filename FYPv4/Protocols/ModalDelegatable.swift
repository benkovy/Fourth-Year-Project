//
//  ModalDelegatable.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-03-12.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import Foundation

protocol ModalDelegatable: class {
    func modalPassingBack(value: [String], forCellAt: IndexPath)
    func modalDidCancel(forCellAt: IndexPath)
}

protocol EditMenuDelegatable: class {
    func menuDidRequestClear(forDay: Int)
    func menuDidRequestAdd(value: [String:Any], forDay: Int)
}
