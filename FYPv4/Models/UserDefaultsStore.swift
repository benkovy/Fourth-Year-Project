//
//  UserDefaultsStore.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-01-19.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import Foundation

final class UserDefaultsStore {
    
    static func store<T: Codable>(persistables: T) {
        guard let data = try? JSONEncoder().encode(persistables) else { return }
        guard let dictionary =  try? JSONSerialization.jsonObject(with: data, options: []) else { return }
        print(String(describing: T.self))
        UserDefaults.standard.set(dictionary, forKey: String(describing: T.self))
     }
    
    static func retrieve<T: Codable>(_ type: T.Type) -> T? {
        guard let results = UserDefaults.standard.value(forKey: String(describing: T.self)) as? [String: Any] else { return nil }
        guard let data = try? JSONSerialization.data(withJSONObject: results, options: []) else { return nil }
        guard let object = try? JSONDecoder().decode(type, from: data) else { return nil }
        return object
    }
    
    static func delete<T: Codable>(withKey: T.Type) {
        UserDefaults.standard.removeObject(forKey: String(describing: T.self))
    }
}
