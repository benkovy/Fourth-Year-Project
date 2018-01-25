//
//  Router.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-01-24.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import Foundation

enum Router {
    case login(username: String, password: String)
    case create(user: User)
    
    private var urlPath: String {
        switch self {
        case .login(let username, let password):
            return "\(username) and \(password)"
        case .create(let user):
            return "\(user)"
        }
    }
    
}
