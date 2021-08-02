import Foundation
import Combine
import Keychain
import Networking
import Config

/**
 First launch:
    1. refreshToken is nil, logged in state will be logged out
 
 Login:
    1. Login repo calls auth with access token and refresh token
    2. Auth stores the tokens, and sets logged in stare to logged in
 
 Logout:
    1. Auth deletes tokens and sets logged in state to logged out
 
 Refresh on app re-open:
    1. App listens to app state, and trigger access token refresh when turning active from background
    2. Force refreshed credentials. Assigns new logged in state, if needed
 
 TODO: Ideas:
    - Unify the concepts of accessToken + refreshToken with the LoggedInState somehow
    - Update tests
    - Don't re-attempt check-session if loggedin state is already needPasscodeRefresh
    - Handle elevated access tokens
 */

public enum LoggedInState {
    case loggedIn
    case needPasscodeRefresh
    case loggedOut
}

public class AuthClient: ObservableObject {
    typealias AccessToken = String
    
    private var refreshToken: String?
    private var accessToken: AccessToken?
    
    private let keychain: KeychainProtocol
    private let networking: NetworkingClient
    private let environment: Environment
    private let queue = DispatchQueue(label: "Autenticator.\(UUID().uuidString)")
    private var bag = Set<AnyCancellable>()
    
    // This publisher is shared amongst all calls that request a access token refresh
    private var refreshPublisher: AnyPublisher<AccessToken, AuthError>?
    
    /// Source of truth for 'Logged in'-state
    @Published public private(set) var isLoggedIn: LoggedInState
    
    private func setLoggedInState(_ newLoggedIn: LoggedInState) {
        if isLoggedIn != newLoggedIn {
            isLoggedIn = newLoggedIn
        }
    }
    
    public init(keychain: KeychainProtocol,
                networking: NetworkingClient,
                environment: Environment,
                refreshCredentialsTrigger: AnyPublisher<Void, Never>) {
        self.keychain = keychain
        self.networking = networking
        self.environment = environment
        self.refreshToken = try? keychain.getKey(.refreshToken)
        self.isLoggedIn = self.refreshToken != nil ? .loggedIn : .loggedOut
        
        refreshCredentialsTrigger
            .sink { [weak self] in
                self?.refreshCredentials()
            }.store(in: &bag)
    }
    
    public func request<T: Decodable, R: NetworkingRequest>(_ request: R) -> AnyPublisher<T, AuthError> {
        
        func requestWithCredentials(_ accessToken: AccessToken) -> AnyPublisher<T, AuthError> {
            networking.request(request, accessToken: accessToken)
                .mapError(AuthError.networkError)
                .eraseToAnyPublisher()
        }
        
        return validAccessToken()
            .flatMap(requestWithCredentials)
            .catch { error -> AnyPublisher<T, AuthError> in
                guard case AuthError.networkError(let networkError) = error,
                      networkError == .accessTokenInvalid else {
                    return Fail(error: error).eraseToAnyPublisher()
                }
                return self.validAccessToken(forceRefresh: true)
                    .flatMap(requestWithCredentials)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    private func validAccessToken(forceRefresh: Bool = false) -> AnyPublisher<AccessToken, AuthError> {
        queue.sync { [weak self] in
            // We're already loading a new token
            if let publisher = self?.refreshPublisher {
                print("[Authenticator] Refresh in progress, returning current 'refreshPublisher'")
                return publisher
            }
            
            // We don't have a token at all
            guard self?.refreshToken != nil else {
                print("[Authenticator] No credentials, need login!")
                return Fail(error: AuthError.noCredentials)
                    .eraseToAnyPublisher()
            }
            
            // We already have a valid token and don't want to force a refresh
            if let accessToken = self?.accessToken, !forceRefresh {
                print("[Authenticator] Using current credentials")
                return Just(accessToken)
                    .setFailureType(to: AuthError.self)
                    .eraseToAnyPublisher()
            }
            
            print("[Authenticator] Requesting refreshed accessToken")
            let publisher = checkSession()
                .flatMap { response -> AnyPublisher<AccessToken, AuthError> in
                    if let accessToken = response.accessToken {
                        return Just(accessToken)
                            .setFailureType(to: AuthError.self)
                            .eraseToAnyPublisher()
                    }
                    
                    if response.refreshToken != nil && response.email != nil {
                        self?.setLoggedInState(.needPasscodeRefresh)
                        return Fail(error: AuthError.needPasscodeRefresh).eraseToAnyPublisher()
                    }
                    
                    self?.setLoggedInState(.loggedOut)
                    return Fail(error: AuthError.noCredentials).eraseToAnyPublisher()
                }
                .handleEvents(receiveOutput: { accessToken in
                    self?.setAccessToken(accessToken)
                }, receiveCompletion: { _ in
                    self?.refreshPublisher = nil
                })
                .share()
                .eraseToAnyPublisher()
            
            self?.refreshPublisher = publisher
            return publisher
        }
    }
    
    public func refresh(with passcode: String) -> AnyPublisher<Void, AuthError> {
        guard refreshToken != nil else {
            return Fail(error: AuthError.noCredentials).eraseToAnyPublisher()
        }
        
        let request: AnyPublisher<RefreshWithPasscode.Response, NetworkingError> = networking
            .request(RefreshWithPasscode(passcode: passcode, environment: environment))
        
        return request
            .print("Refresh request")
            .mapError(AuthError.networkError)
            .handleEvents(receiveOutput: { [weak self] response in
                self?.setAccessToken(response.accessToken)
            })
            .map { _ in () }
            .eraseToAnyPublisher()
    }
    
    public func login(accessToken: String, refreshToken: String) {
        setRefreshToken(refreshToken)
        setAccessToken(accessToken)
        isLoggedIn = .loggedIn
    }
    
    public func logout() {
        setRefreshToken(nil)
        setAccessToken(nil)
        networking.clearCookies()
        isLoggedIn = .loggedOut
    }
    
    private func setRefreshToken(_ refreshToken: String?) {
        queue.sync { [weak self] in
            do {
                if let token = refreshToken {
                    try self?.keychain.setKey(.refreshToken, value: token)
                } else {
                    try self?.keychain.deleteKey(.refreshToken)
                }
                self?.refreshToken = refreshToken
            } catch let error {
                let operation = refreshToken != nil ? "Setting" : "Deleting"
                print("\(operation) \(Key.refreshToken) in keychain failed: \(error.localizedDescription)")
                // TODO: Log this error
                return
            }
        }
    }
    
    private func setAccessToken(_ accessToken: String?) {
        queue.sync { [weak self] in
            self?.accessToken = accessToken
        }
    }
    
    private func refreshCredentials() {
        validAccessToken(forceRefresh: true)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { _ in } )
            .store(in: &bag)
    }
    
    private func checkSession() -> AnyPublisher<CheckSession.Response, AuthError> {
        networking
            .request(CheckSession.init(environment: environment))
            .mapError { _ in AuthError.sessionCheckFailed }
            .eraseToAnyPublisher()
    }
}
