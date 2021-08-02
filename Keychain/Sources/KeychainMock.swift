import Foundation

public class KeychainMock: KeychainProtocol {
    var refreshToken: String?
    
    public convenience init(refreshToken: String? = nil) {
        self.init(service: "keychain.mock.service", accessGroup: "keychain.mock.accessGroup")
        self.refreshToken = refreshToken
    }
    
    public required init(service: String, accessGroup: String?) {}
    
    public func setKey(_ key: Key, value: String) {
        switch key {
        case .refreshToken:
            refreshToken = value
        }
    }
    
    public func getKey(_ key: Key) -> String? {
        switch key {
        case .refreshToken: return refreshToken
        }
    }
    
    public func deleteKey(_ key: Key) {
        switch key {
        case .refreshToken:
            refreshToken = nil
        }
    }
}
