//
//  File.swift
//  
//
//  Created by Martin Wiingaard on 20/05/2021.
//

import Foundation
import Combine
import Alamofire

public class NetworkingClient {
    required public init(userAgent: UserAgent, debug: Bool = false) {
        self.userAgent = userAgent
        self.session = Session(eventMonitors: debug ? [AlamofireLogger()] : [])
        session.sessionConfiguration.httpCookieStorage = cookieStorage
    }
    private let session: Session
    private let userAgent: UserAgent
    private let cookieStorage: HTTPCookieStorage = .sharedCookieStorage(
        forGroupContainerIdentifier: "group.xyz.wiingaard.Pleo.shared-keychain"
    )
    
    public func request<T: Decodable, R: NetworkingRequest>(
        _ request: R,
        accessToken: String? = nil
    ) -> AnyPublisher<T, NetworkingError> {
        
        let headers = HTTPHeaders.default(
            accessToken: accessToken,
            additionalHeaders: request.additionalHeaders.map(HTTPHeader.init),
            userAgent: userAgent,
            cookieStorage: cookieStorage
        )
        
        return session.request(request.url,
                               method: request.payload.method,
                               parameters: request.payload.parameters,
                               encoder: request.payload.encoding,
                               headers: HTTPHeaders(headers)
        )
        .validate(statusCode: [200])
        .publishDecodable(type: T.self,
                          queue: .main,
                          decoder: NetworkingClient.jsonDecoder
        )
        .value()
        .mapError { error in
            if error.responseCode == 401 {
                return NetworkingError.accessTokenInvalid
            }
            // Map AFError do usable NetworkingError
            print("REQUEST FAILED!")
            return NetworkingError.underlyingError
        }
        .eraseToAnyPublisher()
    }
    
    /// Use this to remove the session cookie on log out
    public func clearCookies() {
        cookieStorage.cookies?.forEach { [weak self] cookie in
            self?.cookieStorage.deleteCookie(cookie)
        }
    }
}

extension NetworkingClient {
    private static var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(NetworkingClient.dateDecodingFormatter)
        return decoder
    }
    
    private static var dateDecodingFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-DD'T'HH:mm:ss.SSS'Z'"
        return formatter
    }
}
