//
//  Resource.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-01-24.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import Foundation

struct Resource<A> {
    let request: URLRequest
    let parse: (Data) -> A?
}

extension Resource {
    init(request: URLRequest, parseJSON: @escaping (Any) -> A?) {
        self.request = request
        self.parse = { data in
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            return json.flatMap(parseJSON)
        }
    }
}

