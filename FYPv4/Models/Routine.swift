//
//  Routine.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-03-08.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import Foundation
import UIKit

struct Routine: Codable {
    let id: String?
    let name: String?
    var user_id: String
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
    
    mutating func setUserId(id: String) {
        self.user_id = id
    }
    
    mutating func finalizeDay(number: Int, toWorkout: [WebWorkout], withTags: [String]) {
        var ordered = self.days.sorted(by: {$0.day < $1.day})
        ordered[number] = Day(
            initialized: withTags,
            workoutId: toWorkout.first?.id,
            finalized: toWorkout,
            empty: false,
            id: ordered[number].id,
            day: ordered[number].day,
            routine_id: ordered[number].routine_id)
        self.days = ordered
    }
    
    mutating func initializeDay(number: Int, toValue: [String]) {
        var ordered = self.days.sorted(by: {$0.day < $1.day})
        guard let num = Date.givenDay(section: number) else {return}
        ordered[num] = Day(
            initialized: toValue,
            workoutId: nil,
            finalized: nil,
            empty: false,
            id: ordered[num].id,
            day: ordered[num].day,
            routine_id: ordered[num].routine_id)
        self.days = ordered
    }
    
    mutating func emptyDay(number: Int) {
        var ordered = self.days.sorted(by: {$0.day < $1.day})
        guard let num = Date.givenDay(section: number) else {return}
        ordered[num] = Day(
            initialized: nil,
            workoutId: nil,
            finalized: nil,
            empty: true,
            id: ordered[num].id,
            day: ordered[num].day,
            routine_id: ordered[num].routine_id)
        self.days = ordered
    }
    
    
    func dayType(forDay: Int) -> WorkoutDay {
        guard let num = Date.givenDay(section: forDay) else {return .empty}
        let ordered = self.days.sorted(by: {$0.day < $1.day})
        if ordered[num].empty {
            return .empty
        } else if ordered[num].workoutId != nil {
            return .finalized
        } else if ordered[num].initialized != nil {
            return .initialized
        } else {
            return .empty
        }
    }
}


struct Day: Codable {
    let initialized: [String]?
    let workoutId: String?
    let finalized: [WebWorkout]?
    let empty: Bool
    let id: String?
    let day: Int
    let routine_id: String?
}

extension Day {
    init(day: Int) {
        self.id = nil
        self.workoutId = nil
        self.initialized = nil
        self.empty = true
        self.finalized = nil
        self.routine_id = nil
        self.day = day
    }
    
    enum CodingError: Error { case decoding(String) }
    enum CodingKeys: String, CodingKey {
        case initialized
        case workoutId
        case finalized
        case empty
        case id
        case day
        case routine_id
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if let initialized = try? values.decode([String].self, forKey: Day.CodingKeys.initialized) {
            self.initialized = initialized
        } else {self.initialized = nil}
        
        if let finalized = try? values.decode([WebWorkout].self, forKey: Day.CodingKeys.finalized) {
            self.finalized = finalized
        } else { self.finalized = nil}
        
        if let empty = try? values.decode(Bool.self, forKey: Day.CodingKeys.empty) {
            self.empty = empty
        } else { self.empty = false }
        
        if let id = try? values.decode(String.self, forKey: Day.CodingKeys.id) {
            self.id = id
        } else { self.id = "INVALID ID"}
        
        if let workoutId = try? values.decode(String.self, forKey: Day.CodingKeys.workoutId) {
            self.workoutId = workoutId
        } else { self.workoutId = nil}
        
        if let day = try? values.decode(Int.self, forKey: Day.CodingKeys.day) {
            self.day = day
        } else {  day = 0 }
        
        if let routine_id = try? values.decode(String.self, forKey: Day.CodingKeys.routine_id) {
            self.routine_id = routine_id
        } else { self.routine_id = "NOTHING" }
    }
}


extension Routine {
    static func imageCache(routine: Routine) -> [[UIImage]?] {
        
        var allImages: [[UIImage]?] = []
        routine.days
            .sorted(by: {$0.day < $1.day})
            .forEach { day in
                var workoutImgs: [UIImage] = []
                if let workouts = day.finalized {
                    workouts.forEach { w in
                        if let imgStr = w.image {
                            if let data = Data(base64Encoded: imgStr), let image = UIImage(data: data) {
                                workoutImgs.append(image)
                            }
                        }
                    }
                    if !workoutImgs.isEmpty {
                        allImages.append(workoutImgs)
                    } else {
                        allImages.append(nil)
                    }
                } else { allImages.append(nil) }
        }
        return allImages
    }
}
