//
//  RootViewModel.swift
//  Pleo
//
//  Created by Martin Wiingaard on 05/07/2021.
//

import Foundation
import Combine
import ExpenseFeature
import LoginFeature
import Auth

enum AppRoot {
    case login(vm: LoginViewModel)
    case passcodeRefresh(vm: RefreshPasscodeViewModel)
    case main(vm: ExpenseListViewModel)
    case splash
}

class RootViewModel: ObservableObject {
    private var bag = Set<AnyCancellable>()
    private let dependencies: Dependencies
    @Published var root: AppRoot = .splash
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies

        dependencies.auth.$isLoggedIn
            .map { Self.root(loggedIn: $0, dependencies: dependencies) }
            .print("APP ROOT")
            .sink { [weak self] in self?.root = $0 }
            .store(in: &bag)
    }
    
    static func root(loggedIn: LoggedInState, dependencies: Dependencies) -> AppRoot {
        switch loggedIn {
        case .loggedIn:
            return .main(vm: .init(repo: dependencies.makeExpenseRepo()))
        case .loggedOut:
            return .login(vm: .init(repo: dependencies.makeLoginRepo()))
        case .needPasscodeRefresh:
            return .passcodeRefresh(vm: .init(repo: dependencies.makeLoginRepo()))
        }
    }
}
