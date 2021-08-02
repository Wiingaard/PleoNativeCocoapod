import Foundation

public enum KeychainError: Error {
    case setFailed(key: Key, status: OSStatus)
    case getFailed(key: Key, status: OSStatus)
    case deleteFailed(key: Key?, status: OSStatus)
}

extension KeychainError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .setFailed(key, status):
            return "Set key: '\(key.rawValue)' failed with message: '\(status.errorMessage)'"
        case let .getFailed(key, status):
            return "Get key: '\(key.rawValue)' failed with message: '\(status.errorMessage)'"
        case let .deleteFailed(key, status):
            return "Delete key: '\(key?.rawValue ?? "All keys")' failed with message: '\(status.errorMessage)'"
        }
    }
}

private extension OSStatus {
    var errorMessage: String {
        SecCopyErrorMessageString(self, nil) as String? ?? "Unhandled Error"
    }
}
