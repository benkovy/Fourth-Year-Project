//
//  ModalDelegatable.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-03-12.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import Foundation

protocol ModalDelegatable {
    func modalPassingBack(value: WorkoutType, forCellAt: IndexPath)
    func modalDidCancel(forCellAt: IndexPath)
}
