//
//  File.swift
//  
//
//  Created by Martin Wiingaard on 20/05/2021.
//

import Foundation
import Combine
import Database
import Config
import Auth

protocol ExpenseRepoProtocol {
    func getExpenses() -> AnyPublisher<[Expense], Error>
    func getExpense(id: String) -> AnyPublisher<Expense, Error>
    func updateNote(id: String, note: String?) -> AnyPublisher<Expense, Error>
}

enum ExpenseRepoError: Error {
    case readError
    case writeError
}

public class ExpenseRepo {
    
    private let database: Database
    private let environment: Environment
    private let auth: AuthClient
    
    public init(database: Database, auth: AuthClient, environment: Environment) {
        self.database = database
        self.auth = auth
        self.environment = environment
    }
    
    func getExpenses() -> AnyPublisher<[Expense], ExpenseRepoError> {
        do {
            let expenses = try database.load(domain: .expense, type: [Expense].self)
            return Just.init(expenses)
                .setFailureType(to: ExpenseRepoError.self)
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: ExpenseRepoError.readError).eraseToAnyPublisher()
        }
    }
    
    func writeExpenses() -> AnyPublisher<[Expense], ExpenseRepoError> {
        do {
            try database.store(data: Expense.initialDummyExpenses, in: .expense)
            return Just.init(Expense.initialDummyExpenses)
                .setFailureType(to: ExpenseRepoError.self)
                .eraseToAnyPublisher()
        } catch {
            return Fail.init(error: ExpenseRepoError.writeError).eraseToAnyPublisher()
        }
    }
    
    func fetchExpenses() -> AnyPublisher<[Expense], ExpenseRepoError> {
        let companyId = "3b0628c5-4281-495a-9a5f-789585e95074"
        let getExpenses = GetExpensesRequest(environment: environment, companyId: companyId)
        let request: AnyPublisher<GetExpensesRequest.Response, AuthError> = auth.request(getExpenses)
        return request
            .map { $0.results }
            .mapError { _ in ExpenseRepoError.readError }
            .eraseToAnyPublisher()
    }
    
    func logout() {
        auth.logout()
    }
}

extension Expense {
    static let initialDummyExpenses: [Expense] = [
        .init(id: "1", merchantName: "Martin's Store", performed: "Date()", amount: Amount.init(currency: "DKK", value: 110), isPersonal: false, receipts: [], note: nil),
        .init(id: "2", merchantName: "Diegos's Shop", performed: "Date(timeIntervalSinceNow: 172800)", amount: Amount.init(currency: "DKK", value: 200), isPersonal: false, receipts: [], note: nil),
        .init(id: "3", merchantName: "Osvaldo's Store", performed: "Date(timeIntervalSinceNow: 259200)", amount: Amount.init(currency: "DKK", value: 14.95), isPersonal: false, receipts: [], note: nil),
    ]
}
