//
//  File.swift
//  
//
//  Created by Martin Wiingaard on 25/06/2021.
//

import Foundation
import Networking

public enum AuthError: Error {
    case sessionCheckFailed
    case noCredentials
    case needPasscodeRefresh
    case networkError(NetworkingError)
}
