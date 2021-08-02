// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Networking",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "Networking", targets: ["Networking"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git",
            .upToNextMajor(from: "5.2.0")
        )
    ],
    targets: [
        .target(
            name: "Networking",
            dependencies: [
                .product(name: "Alamofire", package: "Alamofire")
            ],
            path: "Sources"),
        .testTarget(
            name: "NetworkingTests",
            dependencies: ["Networking"],
            path: "Tests")
    ]
)
