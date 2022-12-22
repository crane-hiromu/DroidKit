// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DroidKit",
    platforms: [.iOS("14.0")],
    products: [
        .library(
            name: "DroidKit",
            targets: ["DroidKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/manolofdez/AsyncBluetooth", "1.3.0"..<"2.0.0"),
        .package(url: "https://github.com/michael94ellis/SwiftUIJoystick", "1.5.0"..<"2.0.0")
    ],
    targets: [
        .target(
            name: "DroidKit",
            dependencies: [
                .product(name: "AsyncBluetooth", package: "AsyncBluetooth"),
                .product(name: "SwiftUIJoystick", package: "SwiftUIJoystick")
            ]),
        .testTarget(
            name: "DroidKitTests",
            dependencies: ["DroidKit"]),
    ]
)
