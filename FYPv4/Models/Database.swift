//
//  Database.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-01-10.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import Foundation


final class Database {
    
    init() {
    }
    
    func persist<T: Codable>(_ item: T) {
    }
    
    func getUserToken(completion: @escaping (Result<String>) -> ()) {
    }
    
    func createUser(_ usernamePassword: UsernamePassword, completion: @escaping (Result<Account>) -> ()) {
    }
    
    func signInUser(_ usernamePassword: UsernamePassword, completion: @escaping (Result<Account>) -> ()) {
    }
    
}
