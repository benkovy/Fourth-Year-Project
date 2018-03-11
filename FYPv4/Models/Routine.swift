//
//  Routine.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-03-08.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import Foundation

struct Routine: Codable {
    let ownerId: String
    let ownerName: String
    let name: String
    let isDaybyDay: Bool
    let dayByDay: DayByDay?
    let isCustom: Bool
    let custom: String?
    let id: String?
}
