//
//  RoutineType.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-03-11.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import Foundation

//enum RoutineType: Codable {
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodableKeys.self)
//        if let custom = try? values.decode(String.self, forKey: .custom) {
//            self = .custom(custom)
//            return
//        }
//        if let dayByDay = try? values.decode(DayByDay.self, forKey: .dayByDay) {
//            self = .dayByDay(dayByDay)
//            return
//        }
//        throw CodingError.decoding("Coding error \(dump(values))")
//    }
//    
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodableKeys.self)
//        switch self {
//        case .custom(let string):
//            try container.encode(string, forKey: .custom)
//        case .dayByDay(let dayByDay):
//            try container.encode(dayByDay, forKey: .dayByDay)
//        
//        }
//    }
//    
//    case custom(String)
//    case dayByDay(DayByDay)
//}
//
//extension RoutineType {
//    enum CodingError: Error { case decoding(String) }
//    enum CodableKeys: String, CodingKey {
//        case custom
//        case dayByDay
//    }
//}

