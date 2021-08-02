//
//  ShareViewController.swift
//  Share
//
//  Created by Martin Wiingaard on 02/07/2021.
//

import UIKit
import SwiftUI
import Keychain

class ShareViewController: UIViewController {
    
    let dependencies = Dependencies()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        // Call completion like this:
//        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
//        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
        
        let vm = RootViewModel(dependencies: dependencies)
        let rootView = RootView(vm: vm)
        add(UIHostingController(rootView: rootView))
    }
    
}
