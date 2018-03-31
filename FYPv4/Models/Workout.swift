//
//  Workout.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-01-10.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import Foundation

struct Workout: Codable {
    var name: String
    var creator: String
    var creatorName: String?
    var time: Int
    var description: String?
    var image: Bool
    var rating: Int
    var id: String?
    var tags: [String]
}

extension Workout {
    static func createWorkoutRequest() -> Resource<[Workout]> {
        let workoutRequest = Resource<[Workout]>(Router.workout(amount: 0).request)
        return workoutRequest
    }
    
    static func workoutWithMovementsRequest() -> Resource<[WebWorkout]> {
        let request = Resource<[WebWorkout]>(Router.workoutMovements(amount: 50).request)
        return request
    }
}
