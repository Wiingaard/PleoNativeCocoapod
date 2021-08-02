//
//  File.swift
//  
//
//  Created by Martin Wiingaard on 02/06/2021.
//

import Foundation
import Combine

struct ErrorMessage: Identifiable {
    var id: String { title }
    let title: String
}

public class LoginViewModel: ObservableObject {
    deinit {
        print("Deinit LoginViewModel")
    }
    public init(repo: LoginRepo) {
        self.repo = repo
    }
    private let repo: LoginRepo
    private var bag = Set<AnyCancellable>()
    
    @Published var email: String = "martin.wiingaard+test@pleo.io"
    @Published var loading: Bool = false
    @Published var showPasscodeScreen: PasscodeViewModel? = nil
    @Published var showErrorMessage: ErrorMessage? = nil
    
    var isButtonDisabled: Bool {
        email.count < 5 || loading
    }
    
    enum EmailCheck {
        case pendingInvite
        case legacy
        case regular
    }
    
    private func checkEmail(_ email: String) -> AnyPublisher<EmailCheck, Never> {
        loading = true
        
        let pending = repo
            .checkPendingInvite(email: email)
            .replaceError(with: .init(pending: false))
            .map { $0.pending }
            
        let legacy = repo
            .checkLegacyEmail(email: email)
            .replaceError(with: .init(legacy: false))
            .map { $0.legacy ?? false }
        
        return Publishers.Zip(pending, legacy)
            .map { (pending, legacy) -> EmailCheck in
                if pending {
                    return EmailCheck.pendingInvite
                } else if legacy {
                    return EmailCheck.legacy
                } else {
                    return EmailCheck.regular
                }
            }
            .handleEvents(receiveCompletion: { [weak self] _ in
                self?.loading = false
            })
            .setFailureType(to: Never.self)
            .eraseToAnyPublisher()
    }
    
    func login() {
        print("Login")
        checkEmail(email).sink { [weak self] check in
            switch check {
            case .regular:
                self?.navigateToPasscodeScreen()
            case .pendingInvite, .legacy:
                let detail = check == .pendingInvite ? "'Pending employee invites'" : "'Users with Legacy password login'"
                self?.showErrorMessage = .init(title: "Sorry, this screen does not handle \(detail)")
            }
        }.store(in: &bag)
    }
    
    func navigateToPasscodeScreen() {
        showPasscodeScreen = .init(
            email: email,
            repo: repo
        )
    }
}
