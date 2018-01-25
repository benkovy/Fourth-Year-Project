//
//  WebService.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-01-24.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import Foundation

final class WebService {
    
    private let session = URLSession(configuration: URLSessionConfiguration.ephemeral)
    
    func load<A>(_ resource: Resource<A>, completion: @escaping (Result<A>?) -> ()) {
        session.dataTask(with: resource.request) { (data, _, _) in
            let result = data.flatMap(resource.parse)
            completion(Result(result, or: "Couldn't Parse data"))
        }.resume()
    }
}
