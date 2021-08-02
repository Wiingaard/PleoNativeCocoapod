//
//  File.swift
//  
//
//  Created by Martin Wiingaard on 23/06/2021.
//

import UIKit

public struct Device {
    public static let id = UIDevice.identifier
    public static let osVersion = UIDevice.current.systemVersion
}

extension UIDevice {
    static let identifier: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }()
}
