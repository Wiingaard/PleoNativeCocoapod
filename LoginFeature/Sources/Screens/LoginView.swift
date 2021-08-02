//
//  File.swift
//  
//
//  Created by Martin Wiingaard on 02/06/2021.
//

import Foundation
import SwiftUI
import Utility

public struct LoginView: View {
    public init(vm: LoginViewModel) {
        self.vm = vm
    }
    @ObservedObject var vm: LoginViewModel
    
    var continueButton: some View {
        HStack {
            ActivityIndicator(isAnimating: vm.loading)
            Button("Log in") { [weak vm] in
                vm?.login()
            }
            .disabled(vm.isButtonDisabled)
        }
    }
    
    public var body: some View {
        Form {
            TextField("Email", text: $vm.email)
        }
        .alert(item: $vm.showErrorMessage, content: { error in
            Alert.init(title: Text(error.title))
        })
        .push(item: $vm.showPasscodeScreen) { vm in
            PasscodeView(vm: vm)
        }
        .navigationBarTitle("Login")
        .navigationBarItems(trailing: continueButton)
    }
}

struct SomeOtherView: View {
    let vm: PasscodeViewModel
    
    var body: some View {
        Color.green
    }
}
