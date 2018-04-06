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
    var image: String?
    
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
        case image
    }
}

extension User {
    init() {
        self.firstname = ""
        self.lastname = ""
        self.email = ""
        self.password = ""
        self.description = "You don't have a description! Add one using the button in the top right."
        self.dateofbirth = ""
        self.type = "ACC"
        self.id = nil
        self.token = nil
        self.image = nil
    }
}

extension User {
    
    func userType() -> String {
        return self.type
    }
    
    func userHasToken() -> Bool {
        if self.token == nil {
            return false
        } else {
            return true
        }
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
    
    static func userCreatedWorkouts(token: Token) -> Resource<[WebWorkout]> {
        let userResponse = Resource<[WebWorkout]>(Router.workoutsForUser(token: token).request)
        return userResponse
    }
    
    static func userRoutineWithToken(token: Token) -> Resource<Routine> {
        let userResponse = Resource<Routine>(Router.tokenRoutine(token: token).request)
        return userResponse
    }
    
    static func updateUser(user: User, id: String) -> Resource<User> {
        let userResponse = Resource<User>(Router.updateUser(user: user, id: id).request)
        return userResponse
    }
    
    static func saveRoutine(token: Token, routine: Routine) -> Resource<Routine> {
        let userResponse = Resource<Routine>(Router.saveRoutine(token: token, routine: routine).request)
        return userResponse
    }
    
    
    static func updateUserOnAppLoad(webservice: WebService, token: Token, callback: @escaping (Result<User>) -> ()) {
        webservice.load(User.tokenAuth(token: token)) { (result) in
            guard let result = result else { return }
            switch result {
            case .error(let error):
                callback(Result(nil, or: error.localizedDescription))
            case .success(let newUser):
                callback(Result(newUser, or: ""))
            }
        }
    }
    
    static func userRoutine(webservice: WebService, token: Token, callback: @escaping (Result<Routine>?) -> ()) {
        webservice.load(User.userRoutineWithToken(token: token)) { (result) in
            guard let res = result else { callback(Result(nil, or: "Webservice failure")); return}
            switch res {
            case .error(let error):
                callback(Result(nil, or: error.localizedDescription))
            case .success(let routine):
                callback(Result(routine, or: ""))
            }
        }
    }
    
    static func saveUserRoutine(webservice: WebService, token: Token, routine: Routine, callback: @escaping (Result<Routine>?) -> ()) {
        webservice.load(User.saveRoutine(token: token, routine: routine)) { (result) in
            guard let result = result else { callback(Result(nil, or: "Webservice failure")); return}
            switch result {
            case .error(let error):
                callback(Result(nil, or: error.localizedDescription))
            case .success(let routine):
                callback(Result(routine, or: ""))
            }
        }
    }
}


