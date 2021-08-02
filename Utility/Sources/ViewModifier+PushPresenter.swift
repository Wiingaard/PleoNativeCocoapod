//
//  ViewModifier+PushPresenter.swift
//  PleoNative
//
//  Created by Martin Wiingaard on 04/03/2021.
//

import SwiftUI
import Combine

private struct PushPresenter<Item: Identifiable, DestinationView: View>: ViewModifier {
    
    let item: Binding<Item?>
    let destination: (Item) -> DestinationView
    let presentationBinding: Binding<Bool>
    
    init(item: Binding<Item?>, onDismiss: (() -> Void)? = nil, content: @escaping (Item) -> DestinationView) {
        self.item = item
        self.destination = content
        
        presentationBinding = Binding<Bool> {
            item.wrappedValue != nil
        } set: { isActive in
            if !isActive && item.wrappedValue != nil {
                onDismiss?()
                item.wrappedValue = nil
            }
        }
    }
    
    func body(content: Content) -> some View {
        ZStack {
            content
            NavigationLink(
                destination: item.wrappedValue == nil ? nil : destination(item.wrappedValue!),
                isActive: presentationBinding,
                label: EmptyView.init
            )
        }
    }
}

extension View {
    
    /// Pushed a View onto the navigation stack using the given item as a data source for the View's content.  **Notice**: Make sure to use `.navigationViewStyle(StackNavigationViewStyle())` on the parent `NavigationView` otherwise using this modifier will cause a memory leak.
    /// - Parameters:
    ///   - item: A binding to an optional source of truth for the view's presentation. When `item` is non-nil, the system passes the `item`’s content to the modifier’s closure. This uses a `NavigationLink` under the hood, so make sure to have a `NavigationView` as a parent in the view hierarchy.
    ///   - onDismiss: A closure to execute when poping the view of the navigation stack.
    ///   - content: A closure returning the content of the view.
    public func push<Item: Identifiable, Content: View>(
        item: Binding<Item?>,
        onDismiss: (() -> Void)? = nil,
        content: @escaping (Item) -> Content) -> some View
    {
        self.modifier(
            PushPresenter(
                item: item,
                onDismiss: onDismiss,
                content: content
            )
        )
    }
}
