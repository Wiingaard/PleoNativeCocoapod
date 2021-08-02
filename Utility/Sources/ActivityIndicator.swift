//
//  ActivityIndicator.swift
//  PleoNative
//
//  Created by Martin Wiingaard on 21/02/2021.
//

import SwiftUI

public struct ActivityIndicator: UIViewRepresentable {

    var isAnimating: Bool
    var style: UIActivityIndicatorView.Style = .medium
    
    public init(isAnimating: Bool,style: UIActivityIndicatorView.Style = .medium) {
        self.isAnimating = isAnimating
        self.style = style
    }

    public func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    public func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}
