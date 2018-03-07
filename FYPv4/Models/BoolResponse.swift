//
//  BoolResponse.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-01-26.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import Foundation

struct BoolResponse: Codable {
    let outcome: Bool
}

extension BoolResponse {
    static func requestEmailCheck(_ email: Email) -> Resource<BoolResponse> {
        let resource = Resource<BoolResponse>(request: Router.emailCheck(email: email).request) { json -> BoolResponse? in
            if let data = try? JSONSerialization.data(withJSONObject: json, options: []) {
                return try? JSONDecoder().decode(BoolResponse.self, from: data)
            } else {
                return BoolResponse(outcome: false)
            }
        }
        return resource
    }
    
    static func emailRequest(_ email: Email) -> Resource<BoolResponse> {
        let emailResponse = Resource<BoolResponse>(Router.emailCheck(email: email).request)
        return emailResponse
    }
}
