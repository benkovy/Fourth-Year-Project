//
//  Credentials.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-01-19.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import Foundation

struct UsernamePassword {
    let username: String
    let password: String
}

struct Credentials: Persistable {
    let token: String
    let userId: String
}

