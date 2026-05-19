// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "VigilData",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "VigilData",
            targets: ["VigilData"]
        ),
    ],
    dependencies: [
        .package(path: "../VigilCore")
    ],
    targets: [
        .target(
            name: "VigilData",
            dependencies: ["VigilCore"]
        ),

    ],
    swiftLanguageModes: [.v6]
)
