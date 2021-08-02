//
//  File.swift
//  
//
//  Created by Martin Wiingaard on 23/06/2021.
//

import Foundation

public struct UserAgent: CustomStringConvertible {
    public init(appVersion: String, osVersion: String, deviceId: String) {
        self.appVersion = appVersion
        self.osVersion = osVersion
        self.deviceId = deviceId
    }
    
    private let appVersion: String
    private let osVersion: String
    private let deviceId: String
    
    public var description: String {
        "Pleo/\(appVersion) (iPhone; CPU Apple OS \(osVersion) like Mac OS X; \(deviceId))"
    }
}
