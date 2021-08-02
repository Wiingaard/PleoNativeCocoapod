// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Device",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "Device",
            targets: ["Device"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Device",
            dependencies: [],
            path: "Sources"),
        .testTarget(
            name: "DeviceTests",
            dependencies: ["Device"])
    ]
)
