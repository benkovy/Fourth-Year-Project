//
//  UserDefaultsStore.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-01-19.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import Foundation

final class UserDefaultsStore {
    
    static func store<T: Persistable>(persistables: [T]) {
        let dictionaries = persistables.flatMap { item -> Any? in
            guard let data = try? JSONEncoder().encode(item) else { return nil }
            return try? JSONSerialization.jsonObject(with: data, options: [])
        }
        UserDefaults.standard.set(dictionaries, forKey: T.id)
     }
    
    static func retrieve<T: Persistable>(_ type: T.Type) -> [T] {
        guard let results = UserDefaults.standard.value(forKey: T.id) as? [Any] else { return [] }
        let datas = results.flatMap { data in
            return try? JSONSerialization.data(withJSONObject: data, options: [])
        }
        let objects = datas.flatMap { item in
            return try? JSONDecoder().decode(type, from: item)
        }
        return objects
    }
    
    static func delete<T: Persistable>(withKey: T.Type) {
        UserDefaults.standard.removeObject(forKey: withKey.id)
    }
}
