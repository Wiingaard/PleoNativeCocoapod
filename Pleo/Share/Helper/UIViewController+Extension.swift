//
//  UIViewController+Extension.swift
//  Share
//
//  Created by Martin Wiingaard on 02/07/2021.
//

import UIKit

@nonobjc extension UIViewController {
    func add(_ child: UIViewController) {
        child.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(child)
        view.addSubview(child.view)
        NSLayoutConstraint.activate([
            child.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            child.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            child.view.topAnchor.constraint(equalTo: view.topAnchor),
            child.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        child.didMove(toParent: self)
    }
    
    func remove() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
