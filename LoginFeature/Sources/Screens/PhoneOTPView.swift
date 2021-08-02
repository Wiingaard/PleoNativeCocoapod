//
//  PasscodeView.swift
//
//
//  Created by Martin Wiingaard on 03/06/2021.
//

import SwiftUI
import Utility

struct PhoneOTPView: View {
    @ObservedObject var vm: PhoneOTPViewModel
    
    var continueButton: some View {
        HStack {
            ActivityIndicator(isAnimating: vm.loading)
            Button("Continue") { [weak vm] in
                vm?.login()
            }.disabled(vm.isButtonDisabled)
        }
    }
    
    public var body: some View {
        Form {
            Text("An 'One Time Passcode' has been sent to phone number ending on '\(vm.lastFourDigits)'")
            TextField("OTP", text: $vm.otp)
        }
        .alert(item: $vm.showErrorMessage, content: { error in
            Alert.init(title: Text(error.title))
        })
        .navigationBarTitle("One time password")
        .navigationBarItems(trailing: continueButton)
    }
}
