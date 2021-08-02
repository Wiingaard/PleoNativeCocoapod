import Foundation

public protocol KeychainProtocol {
    init(service: String, accessGroup: String?)
    func setKey(_ key: Key, value: String) throws
    func getKey(_ key: Key) throws -> String?
    func deleteKey(_ key: Key) throws
}

public class KeychainClient: KeychainProtocol {
    private let service: String
    private let accessGroup: String?
    
    public required init(service: String, accessGroup: String? = nil) {
        self.service = service
        self.accessGroup = accessGroup
    }
    
    public func setKey(_ key: Key, value: String) throws {
        guard let valueAsData = value.data(using: .utf8) else {
            fatalError("Failed to encode value: '\(value)' for key: '\(key.rawValue)' as Data")
        }
        var query = query(key)
        
        var status = SecItemCopyMatching(query as CFDictionary, nil)
        switch status {
        case errSecSuccess:
            var attributesToUpdate: [String: Any] = [:]
            attributesToUpdate[String(kSecValueData)] = valueAsData
            status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            if status != errSecSuccess {
                throw KeychainError.setFailed(key: key, status: status)
            }
            
        case errSecItemNotFound:
            query[String(kSecValueData)] = valueAsData
            status = SecItemAdd(query as CFDictionary, nil)
            if status != errSecSuccess {
                throw KeychainError.setFailed(key: key, status: status)
            }
            
        default:
            throw KeychainError.setFailed(key: key, status: status)
        }
    }
    
    public func getKey(_ key: Key) throws -> String? {
        var query = query(key)
        query[String(kSecMatchLimit)] = kSecMatchLimitOne
        query[String(kSecReturnAttributes)] = kCFBooleanTrue
        query[String(kSecReturnData)] = kCFBooleanTrue
        
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, $0)
        }
        
        switch status {
        case errSecSuccess:
            guard
                let queriedItem = queryResult as? [String: Any],
                let passwordData = queriedItem[String(kSecValueData)] as? Data,
                let password = String(data: passwordData, encoding: .utf8)
            else {
                throw KeychainError.getFailed(key: key, status: status)
            }
            return password
        case errSecItemNotFound:
            return nil
        default:
            throw KeychainError.getFailed(key: key, status: status)
        }
    }
    
    public func deleteKey(_ key: Key) throws {
        let query = query(key)
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.deleteFailed(key: key, status: status)
        }
    }
    
    public func deleteAllKeys() throws {
        let query = query()
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.deleteFailed(key: nil, status: status)
        }
    }
    
    private func query(_ key: Key? = nil) -> [String: Any] {
        var query: [String: Any] = [:]
        query[String(kSecClass)] = kSecClassGenericPassword
        query[String(kSecAttrService)] = service
        if let key = key {
            query[String(kSecAttrAccount)] = key.rawValue
        }
        if let accessGroup = accessGroup {
            query[String(kSecAttrAccessGroup)] = accessGroup
        }
        return query
    }
}
