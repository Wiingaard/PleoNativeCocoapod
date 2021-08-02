//
//  File.swift
//  
//
//  Created by Martin Wiingaard on 28/05/2021.
//

import Foundation
import Config
import Networking

struct CheckPendingInvite: NetworkingRequest {
    struct Query: Encodable {
        let email: String
    }
    
    struct Response: Decodable {
        let pending: Bool
    }
    
    let environment: Environment
    let email: String
    var payload: RequestType<Query> {
        .get(query: Query(email: email))
    }
    
    var url: String {
        BaseURL.kerberos.path(for: environment) + "/sca/check/invites"
    }
}
