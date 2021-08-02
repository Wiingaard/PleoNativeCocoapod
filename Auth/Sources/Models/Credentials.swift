//
//  File.swift
//  
//
//  Created by Martin Wiingaard on 25/06/2021.
//

import Foundation

public struct Credentials {
    public init(accessToken: String?, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
    
    public let accessToken: String?
    public let refreshToken: String
    
    
}
