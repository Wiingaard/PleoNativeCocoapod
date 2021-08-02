//
//  File.swift
//  
//
//  Created by Martin Wiingaard on 02/06/2021.
//

import Foundation
import Alamofire

public struct NetworkingHeader {
    let name: String
    let value: String
    
    public static func accept(value: String) -> NetworkingHeader {
        let httpHeader = HTTPHeader.accept(value)
        return NetworkingHeader(name: httpHeader.name, value: httpHeader.value)
    }
    
    public static var acceptApplicationJSON: NetworkingHeader {
        let httpHeader = HTTPHeader.accept("application/json")
        return NetworkingHeader(name: httpHeader.name, value: httpHeader.value)
    }
    
    public static func authorization(bearerToken: String) -> NetworkingHeader {
        let httpHeader = HTTPHeader.authorization(bearerToken: bearerToken)
        return NetworkingHeader(name: httpHeader.name, value: httpHeader.value)
    }
    
    public static var contentJSON: NetworkingHeader {
        let httpHeader = HTTPHeader.contentType("application/json")
        return NetworkingHeader(name: httpHeader.name, value: httpHeader.value)
    }
    
    public static func userAgent(_ userAgent: String) -> NetworkingHeader {
        let httpHeader = HTTPHeader.userAgent(userAgent)
        return NetworkingHeader(name: httpHeader.name, value: httpHeader.value)
    }
}

extension HTTPHeaders {
    static func `default`(
        accessToken: String?,
        additionalHeaders: [HTTPHeader],
        userAgent: UserAgent,
        cookieStorage: HTTPCookieStorage
    ) -> [HTTPHeader] {
        var headers = [
            HTTPHeader.accept("application/json"),
            HTTPHeader.contentType("application/json"),
            HTTPHeader.userAgent(userAgent.description)
        ]
        if let accessToken = accessToken {
            headers.append(HTTPHeader.authorization(bearerToken: accessToken))
        }
        if !additionalHeaders.isEmpty {
            headers.append(contentsOf: additionalHeaders)
        }
        if let cookies = cookieStorage.cookies {
            HTTPCookie.requestHeaderFields(with: cookies).forEach { cookie in
                headers.append(.init(name: cookie.key, value: cookie.value))
            }
        }
        return headers
    }
}

extension HTTPHeader {
    init(_ networkingHeader: NetworkingHeader) {
        self.init(name: networkingHeader.name, value: networkingHeader.value)
    }
}
