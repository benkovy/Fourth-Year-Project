//
//  User.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-01-16.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import Foundation

struct User: Codable {
    var firstname: String
    var lastname: String
    var email: String
    var password: String?
    var description: String
    var dateofbirth: String
    var type: String
    var id: String?
    var token: Token?
    
    var fullName: String? {
        return firstname + " " + lastname
    }
    
    enum CodingKeys: String, CodingKey {
        case firstname
        case lastname
        case email
        case password
        case description
        case dateofbirth
        case type
        case id
        case token
    }
}

extension User {
    init() {
        self.firstname = ""
        self.lastname = ""
        self.email = ""
        self.password = ""
        self.description = "This is my description"
        self.dateofbirth = ""
        self.type = "ACC"
        self.id = nil
        self.token = nil
    }
}

extension User {
    
    func userType() -> String {
        return self.type
    }
    
    static func createUserRequest(_ user: User) -> Resource<User> {
        let userResponse = Resource<User>(Router.create(user: user).request)
        return userResponse
    }
    
    static func loginAndGetToken(_ username: String, _ password: String) -> Resource<User> {
        let userResponse = Resource<User>(Router.loginForUser(username: username, password: password).request)
        return userResponse
    }
    
    static func tokenAuth(token: Token) -> Resource<User> {
        let userResponse = Resource<User>(Router.tokenAuth(token: token).request)
        return userResponse
    }
    
    static func userRoutineWithToken(token: Token) -> Resource<Routine> {
        let userResponse = Resource<Routine>(Router.tokenRoutine(token: token).request)
        return userResponse
    }
    
    
    static func updateUserOnAppLoad(webservice: WebService, token: Token) -> Result<User> {
        var u: User?
        var e = ""
        webservice.load(User.tokenAuth(token: token)) { (result) in
            guard let result = result else { return }
            switch result {
            case .error(let error):
                e = error.localizedDescription
            case .success(let newUser):
                u = newUser
            }
        }
        return Result(u, or: e)
    }
    
    static func userRoutine(webservice: WebService, token: Token) -> Result<Routine> {
        var r: Routine?
        var e = ""
        webservice.load(User.userRoutineWithToken(token: token)) { (result) in
            guard let result = result else { return }
            switch result {
            case .error(let error):
                e = error.localizedDescription
            case .success(let routine):
                r = routine
            }
        }
        return Result(r, or: e)
    }
}


