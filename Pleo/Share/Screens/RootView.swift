import Foundation
import SwiftUI
import LoginFeature
import ExpenseFeature
import Utility

struct RootView: View {
    @ObservedObject var vm: RootViewModel
    
    var body: some View {
        switch vm.root {
        case .splash:
            ActivityIndicator(isAnimating: true)
//            DebugView()
            
        case let .login(vm):
            NavigationView {
                LoginView(vm: vm)
            }.navigationViewStyle(StackNavigationViewStyle())
            
        case let .main(vm):
            ExpenseListView(vm: vm)
            
        case let .passcodeRefresh(vm):
            RefreshPasscodeView(vm: vm)
        }
    }
}
