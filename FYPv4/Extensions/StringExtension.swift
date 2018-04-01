//
//  StringExtension.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-01-20.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import Foundation

extension String: Error {}

extension String {
    static func getTime(row: Int) -> String {
        if row < 60 {
            return "\(row) Seconds"
        }
        let seconds = row % 60
        let minutes = row / 60
        return "\(minutes)m \(seconds)s"
    }
}
