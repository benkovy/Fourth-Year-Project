//
//  WorkoutDay.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-03-10.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import Foundation

enum WorkoutDay: Codable {
    typealias RawValue = String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodableKeys.self)
        
        if let finalized = try? values.decode(Workout.self, forKey: .finalized) {
            self = .finalized(finalized)
            return
        }
        
        if let _ = try? values.decode(String.self, forKey: .initialized) {
            self = .initialized
            return
        }
        
        if let _ = try? values.decode(String.self, forKey: .empty) {
            self = .empty
            return
        }
        
        throw CodingError.decoding("Coding error \(dump(values))")
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodableKeys.self)
        switch self {
        case .empty:
            try container.encode(CodableKeys.empty.rawValue, forKey: .empty)
        case .initialized:
            try container.encode(CodableKeys.initialized.rawValue, forKey: .initialized)
        case .finalized(let work):
            try container.encode(work, forKey: .finalized)
        }
    }
    
    case empty
    case initialized
    case finalized(Workout)
}

extension WorkoutDay {
    enum CodingError: Error { case decoding(String) }
    enum CodableKeys: String, CodingKey {
        case empty
        case initialized
        case finalized
    }
}
