//
//  Routine.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-03-08.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import Foundation

struct Routine: Codable {
    let id: String?
    let name: String
    let user_id: String
    var days: [Day]
}

extension Routine {
    init() {
        self.id = nil
        self.name = "No Name"
        self.user_id = ""
        self.days = Routine.makeEmptyDays()
    }
    
    static func makeEmptyDays() -> [Day] {
        var days: [Day] = []
        for i in 1...7 {
            days.append(Day(day: i))
        }
        return days
    }
    
    mutating func initializeDay(number: Int, toValue: String) {
        var ordered = self.days.sorted(by: {$0.day < $1.day})
        ordered[number] = Day(
            initialized: toValue,
            finalized: nil,
            empty: false,
            id: ordered[number].id,
            day: ordered[number].day,
            routine_id: ordered[number].routine_id)
        self.days = ordered
    }
    
    
    func dayType(forDay: Int) -> WorkoutDay {
        let ordered = self.days.sorted(by: {$0.day < $1.day})
        if ordered[forDay].empty {
            return .empty
        } else if ordered[forDay].finalized != nil {
            return .finalized
        } else if ordered[forDay].initialized != nil {
            return .initialized
        } else {
            return .empty
        }
    }
}


struct Day: Codable {
    let initialized: String?
    let finalized: String?
    let empty: Bool
    let id: String?
    let day: Int
    let routine_id: String?
}

extension Day {
    init(day: Int) {
        self.id = nil
        self.initialized = nil
        self.empty = true
        self.finalized = nil
        self.routine_id = nil
        self.day = day
    }
}
