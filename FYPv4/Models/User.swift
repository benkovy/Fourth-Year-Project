//
//  User.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-01-16.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import Foundation

struct User: Codable {
    let firstName: String?
    let lastName: String?
    let email: String
    let userImage: String?
    let id: String?
    let credentials: Credentials?
    
    var fullName: String? {
        return firstName! + " " + lastName!
    }
}
