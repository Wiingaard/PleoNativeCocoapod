//
//  File.swift
//  
//
//  Created by Martin Wiingaard on 24/06/2021.
//

import Foundation
import Combine
import Keychain
import Config
@testable import Networking

class NetworkingMock: NetworkingProtocol {
    required init(userAgent: UserAgent, environment: Environment, keychain: KeychainClient, debug: Bool) {
        
    }
    
    func request<T, R>(_ request: R) -> AnyPublisher<T, NetworkingError> where T : Decodable, R : NetworkingRequest {
        
    }
}
