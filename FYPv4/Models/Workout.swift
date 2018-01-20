//
//  Workout.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-01-10.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import Foundation

struct Workout: Codable {
    let id: String
    let movements: Movement
    let dateCreated: Int
    let popularity: Int
}
