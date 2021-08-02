//
//  File.swift
//  
//
//  Created by Martin Wiingaard on 28/05/2021.
//

import Foundation

public enum Environment {
    case production
    case staging
    
    func config(production: String, staging: String) -> String {
        switch self {
        case .production:
            return production
        case .staging:
            return staging
        }
    }
}
