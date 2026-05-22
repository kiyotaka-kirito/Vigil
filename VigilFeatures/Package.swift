// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "VigilFeatures",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "VigilFeatures",
            targets: ["VigilFeatures"]
        ),
    ],
    dependencies: [
        .package(path: "../VigilCore"),
        .package(path: "../VigilData")
    ],
    targets: [
        .target(
            name: "VigilFeatures",
            dependencies: ["VigilCore", "VigilData"]
        ),
        .testTarget(
            name: "VigilFeaturesTests",
            dependencies: ["VigilFeatures"]
        ),
    ],
    swiftLanguageModes: [.v6]
)
