//
//  File.swift
//  
//
//  Created by Martin Wiingaard on 30/06/2021.
//

import Foundation
import Combine

public class RefreshPasscodeViewModel: ObservableObject {
    deinit {
        print("Deinit RefreshPasscodeViewModel")
    }
    
    public init(repo: LoginRepo) {
        self.repo = repo
    }
    
    private let repo: LoginRepo
    private var bag = Set<AnyCancellable>()
    
    @Published var loading: Bool = false
    @Published var passcode: String = ""
    @Published var showErrorMessage: ErrorMessage? = nil
    
    var isButtonDisabled: Bool {
        passcode.count != 4 || loading
    }
    
    func refresh() {
        loading = true
        repo.refreshPasscode(passcode)
            .sink(receiveCompletion: { [weak self] completion in
                self?.loading = false
                switch completion {
                case .failure(let error):
                    self?.showErrorMessage = ErrorMessage(title: error.localizedDescription)
                case .finished:
                    break
                }
            },
            receiveValue: { })
            .store(in: &bag)
    }
    
    
}
