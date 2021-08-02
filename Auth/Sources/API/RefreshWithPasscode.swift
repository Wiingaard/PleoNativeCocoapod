//
//  File.swift
//  
//
//  Created by Martin Wiingaard on 30/06/2021.
//

import Foundation
import Networking
import Config

struct RefreshWithPasscode: NetworkingRequest {
    struct Body: Encodable {
        let passcode: String
    }
    
    struct Response: Decodable {
        let accessToken: String
    }
    
    let passcode: String
    let environment: Environment
    
    var payload: RequestType<Body> {
        .post(body: .init(passcode: passcode))
    }
    
    var url: String {
        BaseURL.kerberos.path(for: environment) + "/sca/refresh"
    }
}
