//
//  Persistable.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-01-19.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import Foundation

protocol Persistable: Codable {
    static var id: String { get }
}

extension Persistable {
    static var id: String {
         return String(describing: self)
    }
}
