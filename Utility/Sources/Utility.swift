import Foundation

public func utilityDateFormatter() -> DateFormatter {
    let formatter = DateFormatter.init()
    formatter.dateStyle = .medium
    formatter.timeZone = .none
    return formatter
}
