
import XCTest
import Keychain
import Config
@testable import Networking

final class AuthenticatorTests: XCTestCase {
    func testExample() {
        let authenticator = Authenticator(
            networking: NetworkingMock.init(userAgent: <#T##UserAgent#>, environment: <#T##Environment#>, keychain: <#T##KeychainClient#>, debug: <#T##Bool#>),
            keychain: KeychainClient.init(),
            environment: Environment.staging
        )
    }
    
    
}
