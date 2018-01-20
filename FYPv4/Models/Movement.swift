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
    let bodyPart: BodyPart
    let sets: Int
    let reps: Int
    let restTime: Int
    
    enum BodyPart: String, Codable {
        case shoulder
        case chest
        case leg
        case core
        case bicep
        case tricep
        case back
    }
}
