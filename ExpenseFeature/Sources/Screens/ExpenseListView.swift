//
//  ExpenseListView.swift
//  
//
//  Created by Martin Wiingaard on 25/05/2021.
//

import SwiftUI
import Utility

public struct ExpenseListView: View {
    public init(vm: ExpenseListViewModel) {
        self.vm = vm
    }
    
    @ObservedObject var vm: ExpenseListViewModel
    
    public var body: some View {
        VStack {
            if vm.isLoading {
                ActivityIndicator(isAnimating: vm.isLoading, style: .medium)
            } else {
                HStack {
                    Button("Reload", action: vm.reload)
                    Button("Log out", action: vm.logout)
                }
                List(vm.expenses) { expense in
                    Text(expense.merchantName ?? "NO MERCHANT")
                }
            }
        }.onAppear(perform: vm.loadExpenses)
    }
}
