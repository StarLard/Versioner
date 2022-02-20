// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Versioner",
    products: [
        .executable(name: "versioner", targets: ["Versioner"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.0.3")
    ],
    targets: [
        .executableTarget(
            name: "Versioner",
            dependencies: [.product(name: "ArgumentParser", package: "swift-argument-parser")]),
        .testTarget(
            name: "VersionerTests",
            dependencies: ["Versioner"]),
    ]
)
