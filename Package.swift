// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LogFmt",
    platforms: [
        .macOS(.v10_14)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "LogFmt",
            targets: ["LogFmt"]),
    ],
    dependencies: [
        .package(url: "https://github.com/adamwulf/Locks", branch: "main"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "LogFmt",
            dependencies: [
                .product(name: "Locks", package: "Locks"),
                .product(name: "Logging", package: "swift-log"),
            ]),
        .testTarget(
            name: "LogFmtTests",
            dependencies: ["LogFmt"]),
    ]
)
