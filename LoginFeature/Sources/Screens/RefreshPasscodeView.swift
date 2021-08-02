//
//  File.swift
//  
//
//  Created by Martin Wiingaard on 30/06/2021.
//

import Foundation
import SwiftUI
import Utility

public struct RefreshPasscodeView: View {
    @ObservedObject var vm: RefreshPasscodeViewModel
    
    public init(vm: RefreshPasscodeViewModel) {
        self.vm = vm
    }
    
    var continueButton: some View {
        HStack {
            ActivityIndicator(isAnimating: vm.loading)
            Button("Login", action: vm.refresh)
                .disabled(vm.isButtonDisabled)
        }
    }
    
    public var body: some View {
        Form {
            Text("Welcome back 👋")
            TextField("Passcode", text: $vm.passcode)
            continueButton
        }
        .alert(item: $vm.showErrorMessage, content: { error in
            Alert.init(title: Text(error.title))
        })
    }
}
