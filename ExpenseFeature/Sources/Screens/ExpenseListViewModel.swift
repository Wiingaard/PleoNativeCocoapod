//
//  File.swift
//  
//
//  Created by Martin Wiingaard on 25/05/2021.
//

import Foundation
import Combine

public class ExpenseListViewModel: ObservableObject {
    deinit {
        print("Deinit ExpenseListViewModel")
    }
    
    public init(repo: ExpenseRepo) {
        self.expenseRepo = repo
    }
    
    private let expenseRepo: ExpenseRepo
    private var bag = Set<AnyCancellable>()
    @Published var expenses = [Expense]()
    @Published var isLoading = false
    
    func loadExpenses() {
        isLoading = true
        expenseRepo.fetchExpenses()
            .replaceError(with: [])
            .sink(receiveValue: { [weak self] expenses in
                self?.isLoading = false
                self?.expenses = expenses
            })
            .store(in: &bag)
    }
    
    func reload() {
        expenses = []
        loadExpenses()
    }
    
    func logout() {
        expenseRepo.logout()
    }
}
