// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Keychain",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "Keychain", targets: ["Keychain"])
    ],
    dependencies: [],
    targets: [
        .target(name: "Keychain", dependencies: [], path: "Sources"),
        .testTarget(name: "KeychainTests", dependencies: ["Keychain"])
    ]
)
