// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Config",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "Config",
            targets: ["Config"]),
    ],
    dependencies: [
        // Also most every package will depend on this one, so this package should depend on no-one.
    ],
    targets: [
        .target(
            name: "Config",
            dependencies: [],
            path: "Sources"),
        .testTarget(
            name: "ConfigTests",
            dependencies: ["Config"],
            path: "Tests"),
    ]
)
