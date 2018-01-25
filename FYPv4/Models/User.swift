//
//  User.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-01-16.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import Foundation

struct Account: Persistable {
    let firstName: String?
    let lastName: String?
    let email: String
    let uid: String
    let credentials: Credentials?
    
    var fullName: String? {
        return firstName! + " " + lastName!
    }
}

struct User: Persistable {
    
    var firstname: String
    var lastname: String
    var email: String
    var password: String
    var description: String
    var dateOfBirth: Int
    var type: String
    let uid: String?
    let credentials: Credentials?
    
    var fullName: String? {
        return firstname + " " + lastname
    }
}

extension User {
    func createUserRequest(_ user: User) {
//        let resource = Resource(request: <#T##URLRequest#>, parse: <#T##(Data) -> _?#>)
    }
}

