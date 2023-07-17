// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ErrorAlert",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ErrorAlert",
            targets: ["ErrorAlert"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ErrorAlert"),
        .testTarget(
            name: "ErrorAlertTests",
            dependencies: ["ErrorAlert"]),
    ]
)
