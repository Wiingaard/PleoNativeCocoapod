    import XCTest
    @testable import Config

    final class ConfigTests: XCTestCase {
        func testBaseURL() {
            XCTAssertEqual(BaseURL.deimos.path(for: .production), "https://api.pleo.io")
            XCTAssertEqual(BaseURL.deimos.path(for: .staging), "https://api.staging.pleo.io")
            XCTAssertEqual(BaseURL.kerberos.path(for: .production), "https://auth.pleo.io")
            XCTAssertEqual(BaseURL.kerberos.path(for: .staging), "https://auth.staging.pleo.io")
        }
    }
