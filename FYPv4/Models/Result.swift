//
//  Result.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-01-20.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import Foundation

enum Result<A> {
    case success(A)
    case error(Error)
    
    init(_ value: A?, or error: Error) {
        if let value = value {
            self = .success(value)
        } else {
            self = .error(error)
        }
    }
}
