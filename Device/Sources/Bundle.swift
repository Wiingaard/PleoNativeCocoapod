import Foundation

public extension Bundle {
    static let appVersion: String = {
        guard let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            fatalError("Expected Bundle with 'CFBundleShortVersionString' in 'info.plist'")
        }
        return appVersion
    }()
}
