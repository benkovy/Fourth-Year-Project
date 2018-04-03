//
//  FYP + Int.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-04-02.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import Foundation

extension Int {
    static func randRange (lower: Int , upper: Int) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
    }
}
