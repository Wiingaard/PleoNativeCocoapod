//
//  File.swift
//  
//
//  Created by Martin Wiingaard on 03/06/2021.
//

import Foundation
import Combine

class PasscodeViewModel: ObservableObject, Identifiable {
    deinit {
        print("Deinit PasscodeViewModel")
    }
    
    init(email: String, repo: LoginRepo) {
        self.email = email
        self.repo = repo
    }
    
    private let email: String
    private let repo: LoginRepo
    private var bag = Set<AnyCancellable>()
    
    @Published var loading: Bool = false
    @Published var passcode: String = "1234"
    @Published var showOTPScreen: PhoneOTPViewModel? = nil
    @Published var showErrorMessage: ErrorMessage? = nil
    
    let screenTitle = "Passcode"
    
    var isButtonDisabled: Bool {
        passcode.count != 4 || loading
    }
    
    func verify() {
        loading = true
        repo.validatePasscode(email: email, passcode: passcode)
            .sink { [weak self] _ in
                self?.loading = false
            } receiveValue: { [weak self] response in
                self?.navigateToOTPScreen(lastFourDigits: response.phoneLastDigits)
            }.store(in: &bag)
    }
    
    
    
    private func navigateToOTPScreen(lastFourDigits: String) {
        showOTPScreen = .init(
            email: email,
            passcode: passcode,
            lastFourDigits: lastFourDigits,
            repo: repo
        )
    }
}
