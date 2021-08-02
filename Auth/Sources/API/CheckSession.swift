//
//  File.swift
//  
//
//  Created by Martin Wiingaard on 24/06/2021.
//

import Foundation
import Networking
import Config

struct CheckSession: NetworkingRequest {
    struct Empty: Encodable {}
    
    struct Response: Decodable {
        let accessToken: String?
        let refreshToken: String?
        let email: String?
    }
    
    let environment: Environment
    var payload: RequestType<Empty> = .get(query: .init())
    
    var url: String {
        BaseURL.kerberos.path(for: environment) + "/sca/session"
    }
}
