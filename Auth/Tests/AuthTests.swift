    import XCTest
    import Keychain
    import Combine
    @testable import Auth
    
    final class AuthTests: XCTestCase {
        
        private var bag: Set<AnyCancellable>!
        private var tokenRefresher: TokenRefresher?
        
        override func setUp() {
            super.setUp()
            self.bag = []
            self.tokenRefresher = nil
        }
        
        func testIsLoggedIn() {
            let keychain = KeychainMock(accessToken: "some-access-token", refreshToken: nil)
            let auth = AuthClient(keychain: keychain)
            XCTAssertFalse(auth.isLoggedIn, "Expected 'isLoggedIn' to be 'false' when 'refreshToken' is nil")
            
            auth.setCredentials(.init(accessToken: "some-access-token", refreshToken: "some-refresh-token"))
            XCTAssert(auth.isLoggedIn, "Expected 'isLoggedIn' to be 'true' when 'refreshToken' is set")
            
            auth.setCredentials(.init(accessToken: nil, refreshToken: "some-refresh-token"))
            XCTAssert(auth.isLoggedIn, "Expected 'accessToken' change to have no effext on 'isLoggedIn'")
        }
        
        func testNoCredentials() {
            let keychain = KeychainMock(accessToken: nil, refreshToken: nil)
            let auth = AuthClient(keychain: keychain)
            let response = TokenRefreshResponse(
                accessToken: "access-response",
                refreshToken: "refresh-response",
                email: "some@mail.com"
            )
            tokenRefresher = Tokenator(response: response)
            auth.setTokenRefresher(tokenRefresher!)
            
            let expectation = self.expectation(description: "Token response")
            var authError: AuthError? = nil
            
            auth.validAccessToken()
                .sink(receiveCompletion: { completion in
                    print("completion:", completion)
                    switch completion {
                    case .failure(let error):
                        authError = error
                    default:
                        break
                    }
                    expectation.fulfill()
                }, receiveValue: { _credentials in
                    XCTFail("Didn't expect to receive credentials, when no refresh token is present. \(_credentials)")
                }).store(in: &bag)
            
            waitForExpectations(timeout: 1)
            XCTAssertEqual(authError, AuthError.noCredentials)
        }
        
        func testUseCurrentCredentials() {
            let keychain = KeychainMock(accessToken: "accessToken-keychain", refreshToken: "refreshToken-keychain")
            let auth = AuthClient(keychain: keychain)
            let response = TokenRefreshResponse(
                accessToken: "access-response",
                refreshToken: "refresh-response",
                email: "some@mail.com"
            )
            tokenRefresher = Tokenator(response: response)
            auth.setTokenRefresher(tokenRefresher!)
            
            let expectation = self.expectation(description: "Token response")
            var credentials: Credentials? = nil
            
            auth.validAccessToken()
                .sink(receiveCompletion: { completion in
                    expectation.fulfill()
                }, receiveValue: { _credentials in
                    print("Credentials:", _credentials)
                    credentials = _credentials
                }).store(in: &bag)
            
            waitForExpectations(timeout: 1)
            XCTAssertEqual(credentials?.accessToken, keychain.getKey(.accessToken))
        }
        
        func testRequestCredentials() {
            let keychain = KeychainMock(accessToken: nil, refreshToken: "refreshToken")
            let auth = AuthClient(keychain: keychain)
            let response = TokenRefreshResponse(
                accessToken: "access",
                refreshToken: "refresh",
                email: "some@mail.com"
            )
            tokenRefresher = Tokenator(response: response)
            auth.setTokenRefresher(tokenRefresher!)
            
            let expectation = self.expectation(description: "Token response")
            var credentials: Credentials? = nil
            
            auth.validAccessToken()
                .sink(receiveCompletion: { completion in
                    expectation.fulfill()
                }, receiveValue: { _credentials in
                    credentials = _credentials
                }).store(in: &bag)
            
            waitForExpectations(timeout: 1)
            XCTAssertEqual(credentials?.accessToken, response.accessToken)
        }
        
        func testForceRequest() {
            let keychain = KeychainMock(accessToken: "accessToken-keychain", refreshToken: "refreshToken-keychain")
            let auth = AuthClient(keychain: keychain)
            let response = TokenRefreshResponse(
                accessToken: "access-response",
                refreshToken: "refresh-response",
                email: "some@mail.com"
            )
            tokenRefresher = Tokenator(response: response)
            auth.setTokenRefresher(tokenRefresher!)
            
            let expectation = self.expectation(description: "Token response")
            var credentials: Credentials? = nil
            
            auth.validAccessToken(forceRefresh: true)
                .sink(receiveCompletion: { completion in
                    expectation.fulfill()
                }, receiveValue: { _credentials in
                    credentials = _credentials
                }).store(in: &bag)
            
            waitForExpectations(timeout: 1)
            XCTAssertEqual(credentials?.accessToken, response.accessToken)
        }
        
        func testMultipleRequests() {
            let keychain = KeychainMock(accessToken: nil, refreshToken: "refreshToken")
            let auth = AuthClient(keychain: keychain)
            let response = TokenRefreshResponse(
                accessToken: "access",
                refreshToken: "refresh",
                email: "some@mail.com"
            )
            let refresher = Tokenator(response: response, delay: 0.5)
            tokenRefresher = refresher
            auth.setTokenRefresher(tokenRefresher!)

            let expectation = self.expectation(description: "Token response")
            
            Publishers.CombineLatest3(
                auth.validAccessToken(),
                auth.validAccessToken(),
                auth.validAccessToken()
            ).sink(receiveCompletion: { completion in
                expectation.fulfill()
            }, receiveValue: { _ in })
            .store(in: &bag)

            waitForExpectations(timeout: 1)
            XCTAssertEqual(refresher.requestCount, 1)
        }
        
        func testTokenRefreshFail() {
            let keychain = KeychainMock(accessToken: nil, refreshToken: "refreshToken")
            let auth = AuthClient(keychain: keychain)
            let response = TokenRefreshResponse(
                accessToken: "access",
                refreshToken: "refresh",
                email: "some@mail.com"
            )

            let refresher = Tokenator(response: response, error: .networkRequestFailed)
            tokenRefresher = refresher
            auth.setTokenRefresher(tokenRefresher!)
            
            let expectation = self.expectation(description: "Token response")
            var authError: AuthError? = nil
            
            auth.validAccessToken()
                .sink(receiveCompletion: { completion in
                    print("completion:", completion)
                    switch completion {
                    case .failure(let error):
                        authError = error
                    default:
                        break
                    }
                    expectation.fulfill()
                }, receiveValue: { _credentials in
                    XCTFail("Didn't expect to receive credentials, when no refresh token is present. \(_credentials)")
                }).store(in: &bag)
            
            waitForExpectations(timeout: 1)
            XCTAssertEqual(authError, AuthError.sessionCheckFailed)
        }
    }
    
    class Tokenator: TokenRefresher {
        var response: TokenRefreshResponse
        var error: TokenRefreshError?
        var delay: TimeInterval?
        var requestCount = 0
        
        init(response: TokenRefreshResponse, error: TokenRefreshError? = nil, delay: TimeInterval? = nil) {
            self.response = response
            self.error = error
            self.delay = delay
        }
        
        func refresh() -> AnyPublisher<TokenRefreshResponse, TokenRefreshError> {
            requestCount += 1
            if let error = error {
                return Fail(error: error)
                    .eraseToAnyPublisher()
            } else {
                return Just(response)
                    .delay(for: .seconds(delay ?? 0), scheduler: DispatchQueue.main)
                    .setFailureType(to: TokenRefreshError.self)
                    .eraseToAnyPublisher()
            }
        }
    }
