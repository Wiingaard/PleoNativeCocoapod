//
//  Dependencies.swift
//  Share
//
//  Created by Martin Wiingaard on 05/07/2021.
//

import Foundation
import Networking
import Database
import ExpenseFeature
import LoginFeature
import Config
import Keychain
import Device
import Auth


class Dependencies {
    
    init() {}
    
    lazy var networking: NetworkingClient = .init(
        userAgent: NetworkingClient.userAgent,
        debug: true
    )
    
    lazy var auth: AuthClient = .init(
        keychain: KeychainClient.current,
        networking: networking,
        environment: .current,
        refreshCredentialsTrigger: AppState.didBecomeActive()
    )
    
    func makeExpenseRepo() -> ExpenseRepo {
        ExpenseRepo(
            database: .live,
            auth: auth,
            environment: .current
        )
    }
    
    func makeLoginRepo() -> LoginRepo {
        LoginRepo(
            environment: .current,
            networking: networking,
            auth: auth,
            keychain: .current
        )
    }
}

extension NetworkingClient {
    static let userAgent = UserAgent(
        appVersion: Bundle.appVersion,
        osVersion: Device.osVersion,
        deviceId: Device.id
    )
}

extension Database {
    static let live = Database()
    static let mock = Database()
}

extension Environment {
    static let current = Environment.staging
}

extension KeychainClient {
    static let current = KeychainClient(
        service: "io.pleo.tempKeychain"
    )
}
