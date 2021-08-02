//
//  PasscodeView.swift
//  
//
//  Created by Martin Wiingaard on 03/06/2021.
//

import SwiftUI
import Utility

struct LoadingBarButton: View {
    var title: String
    var loading: Bool = false
    var isDisabled: Bool = false
    var action: () -> ()
    
    var body: some View {
        HStack {
            ActivityIndicator(isAnimating: loading)
            Button(action: action) {
                Text(title)
            }
            .disabled(isDisabled)
        }
    }
}

struct PasscodeView: View {
    @ObservedObject var vm: PasscodeViewModel
    
    var continueButton: some View {
        HStack {
            ActivityIndicator(isAnimating: vm.loading)
            Button("Continue") { [weak vm] in  // <- [weak vm] will avoid the NavBar from capturing vm hence causing memory leak.
                vm?.verify()
            }
            .disabled(vm.isButtonDisabled)
        }
    }
    
    public var body: some View {
        Form {
            TextField("Passcode", text: $vm.passcode)
        }
        .alert(item: $vm.showErrorMessage, content: { error in
            Alert.init(title: Text(error.title))
        })
        .push(item: $vm.showOTPScreen) { vm in
            PhoneOTPView(vm: vm)
        }
        .navigationBarTitle(vm.screenTitle)
//        .navigationBarItems(trailing: Button(action: { [weak vm] in
//            vm?.verify()
//        }, label: {
//            Text("Continue")
//        }))
//        .navigationBarItems(trailing: continueButton)
        .navigationBarItems(trailing:
                                LoadingBarButton(
                                    title: "Continue",
                                    loading: vm.loading,
                                    isDisabled: vm.isButtonDisabled,
                                    action: { [weak vm] in vm?.verify() } // <- [weak vm] will avoid the NavBar from capturing vm hence causing memory leak.
                                )
        )
    }
}
