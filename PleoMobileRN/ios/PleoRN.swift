//
//  PleoRN.swift
//  PleoMobileRN
//
//  Created by Martin Wiingaard on 05/08/2021.
//

import UIKit
import React

class PleoRN {
  static func makeDummyView() -> UIViewController {
    let jsCodeLocation = RCTBundleURLProvider.sharedSettings().resourceURL(
      forResourceRoot: "output",
      resourceName: "rnfeature",
      resourceExtension: ".bundle",
      offlineBundle: nil
    )!
    
    let rootView = RCTRootView(
        bundleURL: jsCodeLocation,
        moduleName: "PleoMobileRN",
        initialProperties: [:] as [NSObject : AnyObject],
        launchOptions: nil
    )
    let vc = UIViewController()
    vc.view = rootView
    return vc
  }
}
