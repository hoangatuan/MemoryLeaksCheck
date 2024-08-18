// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LeaksDetector",
    platforms: [
        .macOS(.v13),
        .iOS(.v15)
    ],
    products: [
        .executable(name: "leaksdetector", targets: ["LeaksDetector"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.0"),
        .package(url: "https://github.com/JohnSundell/ShellOut.git", from: "2.0.0"),
        .package(url: "https://github.com/apple/swift-tools-support-core", from: "0.6.0"),
        .package(url: "https://github.com/davidahouse/XCResultKit.git", exact: "1.2.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .executableTarget(
            name: "LeaksDetector",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "ShellOut",
                .product(name: "SwiftToolsSupport-auto", package: "swift-tools-support-core"),
                .product(name: "XCResultKit", package: "XCResultKit"),
            ]
        ),
        .testTarget(
            name: "LeaksDetectorTests",
            dependencies: ["LeaksDetector"]
        ),
    ]
)
