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
    case loginForUser(username: String, password: String)
    case create(user: User)
    case emailCheck(email: Email)
    case workout(amount: Int)
    
    // Library / Home / Carnagee
    private var urlPath: String {
        switch self {
        case .login(_, _):
            return /*"http://131.162.212.76:8080/login"*/ "http://192.168.2.11:8080/login"
        case .loginForUser(_, _):
            return /*"http://131.162.212.76:8080/login"*/ "http://192.168.2.11:8080/loginForUser"
        case .create(_ ):
            return /*"http://131.162.212.76:8080/users" */ "http://192.168.2.11:8080/users"
        case .emailCheck(_ ):
            return /*"http://131.162.212.76:8080/email" */ "http://192.168.2.11:8080/email"
        case .workout(_):
            return /*"http://131.162.212.76:8080/workout" */ "http://192.168.2.11:8080/workout"
        }
    }
    
    var request: URLRequest {
        let urlString = urlPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        var req = URLRequest(url: URL(string: urlString)!)
        req.httpMethod = method
        req.setValue(contentType, forHTTPHeaderField: headerField)
        req.httpBody = body
        return req
    }
    
    var headerField: String {
        switch self {
        case .login(_, _):
            return "Authorization"
        case .loginForUser(_, _):
            return "Authorization"
        case .create(_ ):
            return "Content-Type"
        case .emailCheck(_ ):
            return "Content-Type"
        case .workout(_ ):
            return "Content-Type"
        }
    }
    
    var method: String {
        switch self {
        case .login(_, _):
            return "POST"
        case .loginForUser(_, _):
            return "POST"
        case .create(_ ):
            return "POST"
        case .emailCheck(_ ):
            return "POST"
        case .workout(_ ):
            return "GET"
        }
    }
    
    var contentType: String {
        switch self {
        case .login(let username, let password):
            let loginString = "\(username):\(password)"
            let data = loginString.data(using: .utf8)
            if let _data = data {
                return "Basic \(_data.base64EncodedString())"
            }
            return ""
        case .loginForUser(let username, let password):
            let loginString = "\(username):\(password)"
            let data = loginString.data(using: .utf8)
            if let _data = data {
                return "Basic \(_data.base64EncodedString())"
            }
            return ""
        case .create(_ ):
            return "application/json"
        case .emailCheck(_ ):
            return "application/json"
        case .workout(_ ):
            return "application/json"
        }
    }
    
    
    var body: Data {
        switch self {
        case .login(_ , _ ):
            return Data()
        case .loginForUser(_ , _ ):
            return Data()
        case .create(let user):
            let data = try? JSONEncoder().encode(user)
            return data ?? Data()
        case .emailCheck(let email):
            let data = try? JSONEncoder().encode(email)
            return data ?? Data()
        case .workout(_ ):
            return Data()
        }
    }
}
