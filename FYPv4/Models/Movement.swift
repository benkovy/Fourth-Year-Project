//
//  Movement.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-01-10.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import Foundation

struct Movement: Codable {
    let name: String
    let description: String
    let sets: Int
    let reps: Int
    let restTime: Int
    let image: Bool
}

extension Movement {
    init() {
        self.name = "New Movement"
        self.description = ""
        self.sets = 0
        self.reps = 0
        self.restTime = 0
        self.image = false
    }
}
