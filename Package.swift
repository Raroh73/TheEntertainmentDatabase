// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "TheEntertainmentDatabase",
    platforms: [
        .macOS(.v13)
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/fluent.git", exact: "4.13.0"),
        .package(url: "https://github.com/vapor/fluent-sqlite-driver.git", exact: "4.8.1"),
        .package(url: "https://github.com/vapor/leaf.git", exact: "4.5.1"),
        .package(url: "https://github.com/vapor/vapor.git", exact: "4.119.0"),
    ],
    targets: [
        .executableTarget(
            name: "TheEntertainmentDatabase",
            dependencies: [
                .product(name: "Fluent", package: "fluent"),
                .product(name: "FluentSQLiteDriver", package: "fluent-sqlite-driver"),
                .product(name: "Leaf", package: "leaf"),
                .product(name: "Vapor", package: "vapor"),
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "TheEntertainmentDatabaseTests",
            dependencies: [
                .target(name: "TheEntertainmentDatabase"),
                .product(name: "VaporTesting", package: "vapor"),
            ],
            swiftSettings: swiftSettings
        ),
    ]
)

var swiftSettings: [SwiftSetting] { [.enableUpcomingFeature("ExistentialAny")] }
