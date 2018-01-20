//
//  Database.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-01-10.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import Foundation
import Firebase


final class Database {
    let ref: DatabaseReference
    
    init() {
        self.ref = Firebase.Database.database().reference()
    }
    
    func persist<T: Codable>(_ item: T) {
        guard let data = try? JSONEncoder().encode(item) else { return }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else { return }
        let name = String(describing: T.self)
        let key = ref.child(name).childByAutoId().key
        let itemToPersist = ["/\(name)/\(key)": json]
        ref.updateChildValues(itemToPersist)
    }
    
    func createUser(_ usernamePassword: UsernamePassword) -> User {
        Auth.auth().createUser(withEmail: usernamePassword.username, password: usernamePassword.password) { user, error in
            print(user)
        }
        return User(firstName: "Ben", lastName: "Kovacs", email: "kovacs1@live.ca", userImage: "sad", id: "asd", credentials: Credentials(token: "asdasd", userId: 1234))
    }
    
    func authenticateUser() {
        
    }
    
}
