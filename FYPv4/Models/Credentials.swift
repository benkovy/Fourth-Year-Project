//
//  Credentials.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-01-19.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import Foundation

struct Token: Codable {
    let token: String
}

struct UsernamePassword {
    let username: String
    let password: String
}

extension Token {
    
    static func getToken(_ username: String, _ password: String) -> Resource<Token> {
        let resource = Resource<Token>(Router.login(username: username, password: password).request)
        return resource
    }
    
}
