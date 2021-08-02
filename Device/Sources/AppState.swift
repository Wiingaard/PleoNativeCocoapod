//
//  File.swift
//  
//
//  Created by Martin Wiingaard on 30/06/2021.
//

import UIKit
import Combine

// This is a iOS 13 capable substitute for [ScenePhase](https://developer.apple.com/documentation/swiftui/scenephase)
public enum AppState {
    /// The app is on-screen, but not active. For instance, when the swipe-up gesture is active while closing or switching app
    case inactive
    
    /// The app is on-screen and running
    case active
    
    /// The app is running in the background. It has not been force killed, but is not on screen.
    case background
    
    private init?(_ state: UIApplication.State) {
        switch state {
        case .active: self = .active
        case .inactive: self = .inactive
        case .background: self = .background
        @unknown default: return nil
        }
    }
    
    /// The current `AppState`. Starts with current value, and publishes changes.
    public static func current() -> AnyPublisher<AppState, Never> {
        let active = NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification).map { _ in AppState.active }
        let inactive = NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification).map { _ in AppState.inactive }
        let background = NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification).map { _ in AppState.background }
        
        return Publishers.Merge3(active, inactive, background)
            .map(Optional.init)
            .prepend(AppState(UIApplication.shared.applicationState))
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }
    
    /// Use this to check if the app transistions between `active` and `background`.
    public static func isActive() -> AnyPublisher<Bool, Never> {
        current()
            .filter { $0 != .inactive }
            .map { $0 == .active }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    /// Use this as a trigger for when the app becomes `active` in foreground
    public static func didBecomeActive() -> AnyPublisher<Void, Never> {
        isActive()
            .filter { $0 }
            .map { _ in () }
            .eraseToAnyPublisher()
    }
}

