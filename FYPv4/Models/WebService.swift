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
        print("ASKING TO LOAD")
        session.dataTask(with: resource.request) { (data, _, _) in
            print("LOADING...")
            let result = data.flatMap(resource.parse)
            self.printData(data)
            completion(Result(result, or: "Couldn't Parse data"))
        }.resume()
    }
    
    private func printData(_ data: Data?) {
        if let _data = data {
            let json = try? JSONSerialization.jsonObject(with: _data, options: [])
            print(json ?? "json conversion didnt work")
        }
    }
}
