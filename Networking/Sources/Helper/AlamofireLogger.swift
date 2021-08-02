//
//  File.swift
//  
//
//  Created by Martin Wiingaard on 02/06/2021.
//

import Foundation
import Alamofire

class AlamofireLogger: EventMonitor {

    func request<Value>(_ request: DataRequest, didParseResponse response: AFDataResponse<Value>) {
        debugPrint(response)
    }
    
}

