// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PrintNii",
    products: [
        .executable(name: "printNii", targets: ["PrintNii"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.3.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "PrintNii",
            dependencies:
            ["PrintNiiCore"]),
        .target(
            name: "PrintNiiCore",
            dependencies: [
                "NiiHdrCore",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]),
        .target(
            name: "NiiHdrCore",
            dependencies: []),
        .testTarget(
            name: "PrintNiiTests",
            dependencies: ["PrintNiiCore"]),
    ]
)
