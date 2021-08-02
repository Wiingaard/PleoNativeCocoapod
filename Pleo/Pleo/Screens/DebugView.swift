//
//  DebugView.swift
//  Pleo
//
//  Created by Martin Wiingaard on 05/07/2021.
//

import Foundation
import Combine
import SwiftUI
import Keychain

class DebugViewModel: ObservableObject {
    var bag = Set<AnyCancellable>()
    
    let keychain = KeychainClient.init(service: "io.pleo.tempKeychain")
    
    func set(_ key: Key) {
        do {
            try keychain.setKey(key, value: key.rawValue)
            print("Did set key:", key)
        } catch let error {
            print("Store failed:", error)
        }
    }
    
    func get(_ key: Key) {
        do {
            let key = try keychain.getKey(key)
            print("Did get key:", key ?? "nil")
        } catch let error {
            print("Store failed:", error)
        }
    }
    
    func delete(_ key: Key) {
        do {
            try keychain.deleteKey(key)
            print("Did delete key:", key)
        } catch let error {
            print("Delete failed:", error)
        }
    }
    
    func deleteAll() {
        do {
            try keychain.deleteAllKeys()
            print("Did deletea all keys")
        } catch let error {
            print("Delete failed:", error)
        }
    }
}

struct DebugView: View {
    let vm = DebugViewModel()

    var body: some View {
        VStack {
//            Text("Get")
//            HStack {
//                Button("Access") {
//                    vm.get(.accessToken)
//                }
//                Button("Refresn") {
//                    vm.get(.refreshToken)
//                }
//            }.padding(.bottom, 10)
//
//            Text("Set")
//            HStack {
//                Button("Access") {
//                    vm.set(.accessToken)
//                }
//                Button("Refresh") {
//                    vm.set(.refreshToken)
//                }
//            }.padding(.bottom, 10)
//
//            Text("Delete")
//            HStack {
//                Button("Access") {
//                    vm.delete(.accessToken)
//                }
//                Button("Refresh") {
//                    vm.delete(.refreshToken)
//                }
//                Button("All") {
//                    vm.deleteAll()
//                }
//            }
        }
    }
}
