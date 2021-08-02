//
//  File.swift
//
//
//  Created by Martin Wiingaard on 28/05/2021.
//

import Foundation
import Config
import Networking

struct Login: NetworkingRequest {
    struct Body: Encodable {
        let email: String
        let otp: String
        let trust: Bool
        let passcode: String?
        let loginToken: String?
    }
    
    let environment: Environment
    let email: String
    let otp: String
    let passcode: String?
    var loginToken: String? = nil
    
    var payload: RequestType<Body> {
        .post(body: Body(
                email: email,
                otp: otp,
                trust: true,
                passcode: passcode,
                loginToken: loginToken)
        )
    }
    
    var url: String {
        BaseURL.kerberos.path(for: environment) + "/sca/login"
    }
}
