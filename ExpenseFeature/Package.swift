// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ExpenseFeature",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "ExpenseFeature",
            targets: ["ExpenseFeature"]),
    ],
    dependencies: [
        .package(path: "../Utility"),
        .package(path: "../Database"),
        .package(path: "../Networking"),
        .package(path: "../Auth"),
        .package(path: "../Config"),
    ],
    targets: [
        .target(
            name: "ExpenseFeature",
            dependencies: [
                .product(name: "Utility", package: "Utility"),
                .product(name: "Database", package: "Database"),
                .product(name: "Networking", package: "Networking"),
                .product(name: "Auth", package: "Auth"),
                .product(name: "Config", package: "Config"),
            ],
            path: "Sources"),
        .testTarget(
            name: "ExpenseFeatureTests",
            dependencies: ["ExpenseFeature"],
            path: "Tests"),
    ]
)
