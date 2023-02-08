// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-apdu",
    platforms: [
        .iOS(.v13),
        .macOS(.v12),
    ],
    products: [
        .library(name: "APDU", targets: ["APDU"]),
    ],
    dependencies: [
        .package(url: "https://github.com/whalescorp/buffbit", .upToNextMajor(from: "0.1.0")),
    ],
    targets: [
        .target(
            name: "APDU",
            dependencies: [
                .product(name: "Buffbit", package: "buffbit"),
            ],
            path: "Sources/APDU",
            swiftSettings: [
                .define("DEBUG", .when(configuration: .debug)),
            ]
        ),
    ]
)
