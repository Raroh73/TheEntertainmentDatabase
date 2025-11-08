// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "TheEntertainmentDatabase",
    platforms: [
        .macOS(.v13)
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", exact: "4.119.0")
    ],
    targets: [
        .executableTarget(
            name: "TheEntertainmentDatabase",
            dependencies: [
                .product(name: "Vapor", package: "vapor")
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
