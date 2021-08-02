// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LoginFeature",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "LoginFeature",
            targets: ["LoginFeature"]),
    ],
    dependencies: [
        .package(path: "../Networking"),
        .package(path: "../Config"),
        .package(path: "../Keychain"),
        .package(path: "../Auth"),
    ],
    targets: [
        .target(
            name: "LoginFeature",
            dependencies: [
                .product(name: "Networking", package: "Networking"),
                .product(name: "Config", package: "Config"),
                .product(name: "Keychain", package: "Keychain"),
                .product(name: "Auth", package: "Auth")
            ],
            path: "Sources"),
        .testTarget(
            name: "LoginFeatureTests",
            dependencies: ["LoginFeature"]),
    ]
)
