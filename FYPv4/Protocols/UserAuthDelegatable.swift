//
//  UserAuthDelegatable.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-03-08.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import Foundation
import UIKit

protocol UserAuthDelegatable {
    func userIsAuthenticated() -> Bool
}

extension UserAuthDelegatable {
    func userIsAuthenticated() -> Bool {
        return UserDefaultsStore.retrieve(User.self)?.token != nil ? true : false
    }
}
