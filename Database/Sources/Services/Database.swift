import Foundation

public struct Database {
    
    public init() {}
    
    public func load<T: Decodable>(domain: DatabaseDomain, type: T.Type) throws -> T {
        let pathWithFilename = try Database.domainUrl(for: domain)
        
        do {
            let data = try Data(contentsOf: pathWithFilename)
            let decoder = JSONDecoder()
            return try decoder.decode(type, from: data)
        } catch {
            throw DatabaseError.decodingError
        }
    }
    
    public func store<T: Encodable>(data: T, in domain: DatabaseDomain) throws {
        let pathWithFilename = try Database.domainUrl(for: domain)
        let json = try jsonEncode(data)
        do {
            try json.write(to: pathWithFilename, atomically: true, encoding: .utf8)
        } catch {
            throw DatabaseError.writeError
        }
    }
    
    func jsonEncode<T: Encodable>(_ data: T) throws -> String {
        let encoder = JSONEncoder()
        guard let encoded = try? encoder.encode(data) else {
            throw DatabaseError.encodingError
        }
        guard let json = String(data: encoded, encoding: .utf8) else {
            throw DatabaseError.encodingError
        }
        return json
    }
}

extension Database {
    static func domainUrl(for domain: DatabaseDomain) throws -> URL {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw DatabaseError.filePathError
        }
        return documentDirectory.appendingPathComponent("\(domain.rawValue).json")
    }
}
