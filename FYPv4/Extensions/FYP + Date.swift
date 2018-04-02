//
//  FYP + Date.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-03-07.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import Foundation

extension Date {
    static func now(withFormat format: String) -> String? {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    static func dayOfTheWeek(plusOffset offset: Int = 0) -> String? {
        let date = Date()
        guard let day = Calendar.current.date(byAdding: .day, value: offset, to: date) else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter.string(from: day)
    }
    
    static func getDayOfWeek() -> Int {
        let todayDate = Date()
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        return weekDay
    }
    
    static func givenDay(section: Int) -> Int? {
        let date = Date()
        guard let day = Calendar.current.date(byAdding: .day, value: section, to: date) else { return nil }
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: day)
        return weekDay - 1
    }
}
