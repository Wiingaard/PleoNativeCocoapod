// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Auth",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "Auth",
            targets: ["Auth"]),
    ],
    dependencies: [
        .package(path: "../Keychain"),
        .package(path: "../Config"),
        .package(path: "../Networking")
    ],
    targets: [
        .target(
            name: "Auth",
            dependencies: [
                .product(name: "Keychain", package: "Keychain"),
                .product(name: "Config", package: "Config"),
                .product(name: "Networking", package: "Networking"),
            ],
            path: "Sources"),
        .testTarget(
            name: "AuthTests",
            dependencies: ["Auth"],
            path: "Tests"),
    ]
)
