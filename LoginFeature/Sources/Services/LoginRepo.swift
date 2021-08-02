//
//  File.swift
//  
//
//  Created by Martin Wiingaard on 02/06/2021.
//

import Foundation
import Combine
import Networking
import Config
import Keychain
import Auth

enum AuthRepoError: Error {
    case someError
}

public struct Credentials: Decodable {
    let accessToken: String
    let refreshToken: String
}

public class LoginRepo: ObservableObject {
    let environment: Environment
    let networking: NetworkingClient
    let auth: AuthClient
    let keychain: KeychainClient
    
    public init(environment: Environment, networking: NetworkingClient, auth: AuthClient, keychain: KeychainClient) {
        self.environment = environment
        self.networking = networking
        self.auth = auth
        self.keychain = keychain
    }
    
    func checkPendingInvite(email: String) -> AnyPublisher<CheckPendingInvite.Response, AuthRepoError> {
        networking.request(CheckPendingInvite(environment: environment, email: email))
            .mapError { _ in AuthRepoError.someError }
            .eraseToAnyPublisher()
    }
    
    func checkLegacyEmail(email: String) -> AnyPublisher<EmailLegacyCheck.Response, AuthRepoError> {
        let request: AnyPublisher<EmailLegacyCheck.Response, NetworkingError> = networking.request(
            CheckPendingInvite(environment: environment, email: email)
        )
        return request
            .mapError { _ in AuthRepoError.someError }
            .eraseToAnyPublisher()
    }
    
    func validatePasscode(email: String, passcode: String) -> AnyPublisher<OneTimePassword.Response, AuthRepoError> {
        let request: AnyPublisher<OneTimePassword.Response, NetworkingError> = networking.request(
            OneTimePassword(environment: environment, email: email, passcode: passcode)
        )
        return request
            .mapError { _ in AuthRepoError.someError }
            .eraseToAnyPublisher()
    }
    
    func login(email: String, passcode: String, otp: String) -> AnyPublisher<Credentials, AuthRepoError> {
        let request: AnyPublisher<Credentials, NetworkingError> = networking.request(
            Login(environment: environment, email: email, otp: otp, passcode: passcode)
        )
        return request
            .mapError { _ in AuthRepoError.someError }
            .handleEvents(receiveOutput: { [weak self] credentials in
                self?.didLogin(credentials: credentials)
            })
            .eraseToAnyPublisher()
    }
    
    func refreshPasscode(_ passcode: String) -> AnyPublisher<Void, AuthError> {
        auth.refresh(with: passcode)
    }
    
    private func didLogin(credentials: Credentials) {
        auth.login(accessToken: credentials.accessToken, refreshToken: credentials.refreshToken)
    }
}
