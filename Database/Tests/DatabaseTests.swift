    import XCTest
    @testable import Database
    
    final class DatabaseTests: XCTestCase {
        
        func testJsonEncode() {
            struct SomeStruct: Codable {
                let message: String
            }
            
            let database = Database()
            let hello = SomeStruct(message: "Hello, World!")
            let encoded = try? database.jsonEncode(hello)
            XCTAssertEqual(encoded, Optional.some("{\"message\":\"Hello, World!\"}"))
        }
        
        func testDomain() {
            let domain = try? Database.domainUrl(for: .expense)
            XCTAssertEqual(domain?.lastPathComponent, Optional("expense.json"))
        }
    }
