// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Repository",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "Repository",
            targets: ["Repository"]
        )
    ],
    dependencies: [
        .package(path: "../Core"),
        .package(path: "../Utilities"),
    ],
    targets: [
        .target(
            name: "Repository",
            dependencies: [
                "Core",
                "Utilities",
            ]
        ),
        .testTarget(
            name: "RepositoryTests",
            dependencies: ["Repository", "Core"]
        ),
    ]
)
