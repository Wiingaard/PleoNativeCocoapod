//
//  Expense.swift
//  
//
//  Created by Martin Wiingaard on 20/05/2021.
//

import Foundation

struct Expense: Codable, Identifiable {
    let id: String
    let merchantName: String?
    let performed: String
    let amount: Amount
    let isPersonal: Bool
    let receipts: [Receipt]
    let note: String?
}
