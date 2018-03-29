//
//  WebWorkout.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-03-28.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import Foundation

struct WebWorkout: Codable {
    var name: String
    var creator: String
    var creatorName: String?
    var time: Int
    var description: String?
    var image: Bool
    var rating: Int
    var id: String?
    let movements: [Movement]?
}

extension WebWorkout {
    init(workout: Workout, movements: [Movement]) {
        self.name = workout.name
        self.creator = workout.creator
        self.description = workout.description
        self.time = workout.time
        self.creatorName = workout.creatorName
        self.image = workout.image
        self.rating = workout.rating
        self.id = workout.id
        self.movements = movements
    }
    
    static func postWorkout(token: Token, workout: WebWorkout) -> Resource<Workout> {
        let userResponse = Resource<Workout>(Router.postWorkout(workout: workout).request)
        return userResponse
    }
    
    
    static func saveWorkout(webservice: WebService, token: Token, workout: WebWorkout, callback: @escaping (Result<Workout>) -> ()) {
        webservice.load(WebWorkout.postWorkout(token: token, workout: workout), completion: { res in
            guard let result = res else { callback(Result(nil, or: "Response failure")); return }
            switch result {
            case .error(let error):
                callback(Result(nil, or: error.localizedDescription))
            case .success(let w):
                callback(Result(w, or: ""))
            }
        })
        
        
    }
}
