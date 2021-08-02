//
//  File.swift
//  
//
//  Created by Martin Wiingaard on 28/05/2021.
//

import Foundation

public enum BaseURL {
    case deimos
    case kerberos
    
    public func path(for environment: Environment) -> String {
        switch self {
        case .deimos:
            return environment.config(
                production: "https://api.pleo.io",
                staging: "https://api.staging.pleo.io"
            )
            
        case .kerberos:
            return environment.config(
                production: "https://auth.pleo.io",
                staging: "https://auth.staging.pleo.io"
            )
        }
    }
}
