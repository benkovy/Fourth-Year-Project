//
//  WorkoutType.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-03-08.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import Foundation

fileprivate struct WorkoutTypeHelper {
    static let KeyTypes: [WorkoutType.CodableKeys] = [.chest, .back, .shoulder, .arm, .leg, .push, .pull, .hiit, .athletic, .functional, .crossfit, .stretch, .random]
    
    static let Types: [WorkoutType] = [.chest, .back, .shoulder, .arm, .leg, .push, .pull, .hiit, .athletic, .functional, .crossfit, .stretch, .random]
}

enum WorkoutType: Codable {
    typealias RawValue = String
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodableKeys.self)
        switch self {
        case .chest:
            try container.encode(CodableKeys.chest.rawValue, forKey: .chest)
        case .back:
            try container.encode(CodableKeys.back.rawValue, forKey: .back)
        case .shoulder:
            try container.encode(CodableKeys.shoulder.rawValue, forKey: .shoulder)
        case .arm:
            try container.encode(CodableKeys.arm.rawValue, forKey: .arm)
        case .leg:
            try container.encode(CodableKeys.leg.rawValue, forKey: .leg)
        case .push:
            try container.encode(CodableKeys.push.rawValue, forKey: .push)
        case .pull:
            try container.encode(CodableKeys.pull.rawValue, forKey: .pull)
        case .hiit:
            try container.encode(CodableKeys.hiit.rawValue, forKey: .hiit)
        case .athletic:
            try container.encode(CodableKeys.athletic.rawValue, forKey: .athletic)
        case .functional:
            try container.encode(CodableKeys.functional.rawValue, forKey: .functional)
        case .crossfit:
            try container.encode(CodableKeys.crossfit.rawValue, forKey: .crossfit)
        case .stretch:
            try container.encode(CodableKeys.stretch.rawValue, forKey: .stretch)
        case .random:
            try container.encode(CodableKeys.random.rawValue, forKey: .random)
        case .other(let str):
            try container.encode(str, forKey: .other)
        }
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodableKeys.self)
        
        if let other = try? values.decode(String.self, forKey: .other) {
            self = .other(other)
            return
        }
        
        for type in WorkoutTypeHelper.KeyTypes {
            if let _ = try? values.decode(String.self, forKey: type) {
                
                guard let index = WorkoutTypeHelper.KeyTypes.index(of: type) else {
                    throw CodingError.decoding("Coding error \(dump(values))")
                }
                
                self = WorkoutTypeHelper.Types[index]
                return
            }
        }
        throw CodingError.decoding("Coding error \(dump(values))")
    }
    
    case chest
    case back
    case shoulder
    case arm
    case leg
    case push
    case pull
    case hiit
    case athletic
    case functional
    case crossfit
    case stretch
    case random
    case other(String)
}

extension WorkoutType {
    
    enum CodingError: Error { case decoding(String) }
    enum CodableKeys: String, CodingKey {
        case chest
        case back
        case shoulder
        case arm
        case leg
        case push
        case pull
        case hiit
        case athletic
        case functional
        case crossfit
        case stretch
        case random
        case other
    }
}
