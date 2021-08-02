//
//  File.swift
//
//
//  Created by Martin Wiingaard on 03/06/2021.
//

import Foundation
import Combine

class PhoneOTPViewModel: ObservableObject, Identifiable {
    deinit {
        print("Deinit PhoneOTPViewModel")
    }
    
    init(email: String, passcode: String, lastFourDigits: String, repo: LoginRepo) {
        self.email = email
        self.passcode = passcode
        self.repo = repo
        self.lastFourDigits = lastFourDigits
    }
    
    private let email: String
    private let passcode: String
    private let repo: LoginRepo
    let lastFourDigits: String
    private var bag = Set<AnyCancellable>()
    
    @Published var loading: Bool = false
    @Published var otp: String = "123456"
    @Published var showErrorMessage: ErrorMessage? = nil
    
    var isButtonDisabled: Bool {
        otp.count != 6 || loading
    }
    
    func login() {
        loading = true
        repo.login(email: email, passcode: passcode, otp: otp)
            .sink { [weak self] _ in
                self?.loading = false
            } receiveValue: { response in
                debugPrint(response)
            }.store(in: &bag)
    }
}
