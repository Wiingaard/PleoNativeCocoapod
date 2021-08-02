//
//  File.swift
//  
//
//  Created by Martin Wiingaard on 03/06/2021.
//

import Foundation
import Config
import Networking

struct EmailLegacyCheck: NetworkingRequest {
    struct Query: Encodable {
        let email: String?
        let refreshToken: String?
    }
    
    struct Response: Decodable {
        let legacy: Bool?
    }
    
    let environment: Environment
    let email: String
    var refreshToken: String? = nil
    var payload: RequestType<Query> {
        .get(query: Query(email: email, refreshToken: refreshToken))
    }
    
    var url: String {
        BaseURL.kerberos.path(for: environment) + "/sca/check"
    }
}
