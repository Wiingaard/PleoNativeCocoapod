//
//  DatabaseError.swift
//  
//
//  Created by Martin Wiingaard on 20/05/2021.
//

import Foundation

enum DatabaseError: Error {
    case encodingError
    case writeError
    case decodingError
    case readError
    case filePathError
}
