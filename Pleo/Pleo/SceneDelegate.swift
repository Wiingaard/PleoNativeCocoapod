//
//  SceneDelegate.swift
//  Pleo
//
//  Created by Martin Wiingaard on 06/05/2021.
//

import UIKit
import SwiftUI
import Database

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let dependencies = Dependencies()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        let vm = RootViewModel(dependencies: dependencies)
        let rootView = RootView(vm: vm)
        
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: rootView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}

