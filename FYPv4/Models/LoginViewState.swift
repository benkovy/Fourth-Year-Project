//
//  LoginViewState.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-01-20.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import Foundation

enum LoginViewState {
    case login
    case create
    
    mutating func changeState() {
        switch self {
        case .login: self = .create
        case .create: self = .login
        }
    }
    
    var authButton: String {
        switch self {
        case .create: return "Create"
        case .login: return "Login"
        }
    }
    
    var toggleButton: String {
        switch self {
        case .create: return "Already have an account? Login"
        case .login: return "No account? Create one!"
        }
    }
    
    var isHidden: Bool {
        switch self {
        case .create: return false
        case .login: return true
        }
    }
}
