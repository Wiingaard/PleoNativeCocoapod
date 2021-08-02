//
//  Request.swift
//  
//
//  Created by Martin Wiingaard on 20/05/2021.
//

import Foundation
import Alamofire

public protocol NetworkingRequest {
    associatedtype P: Encodable
    var payload: RequestType<P> { get }
    var url: String { get }
    var additionalHeaders: [NetworkingHeader] { get }
}

public extension NetworkingRequest {
    var additionalHeaders: [NetworkingHeader] { .init() }
}

public enum RequestType<Parameters: Encodable> {
    case post(body: Parameters)
    case get(query: Parameters)
}

extension RequestType {
    var parameters: Parameters {
        switch self {
        case .get(let query): return query
        case .post(let body): return body
        }
    }
    
    var encoding: ParameterEncoder {
        switch self {
        case .get: return URLEncodedFormParameterEncoder.default
        case .post: return JSONParameterEncoder.default
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .get: return .get
        case .post: return .post
        }
    }
}
