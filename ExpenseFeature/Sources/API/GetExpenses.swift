//
//  File.swift
//  
//
//  Created by Martin Wiingaard on 20/05/2021.
//

import Foundation
import Networking
import Config

struct GetExpensesRequest: NetworkingRequest {
    struct Body: Encodable {
        let excludeManualExpenses = false
        let excludeManualTransfers = false
        let limit = 25
    }
    
    struct Response: Decodable {
        let lastUpdated: Date
        let lastCreated: Date
        let total: Int
        let results: [Expense]
    }
    
    let environment: Environment
    let companyId: String
    
    var payload = RequestType.post(body: Body())
    
    var url: String {
        BaseURL.deimos.path(for: environment) + "/rest/v1/companies/\(companyId)/expenses"
    }
}
