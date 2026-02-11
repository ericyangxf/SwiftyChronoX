// swift-tools-version:6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftyChronoX",
    products: [
        .library(
            name: "SwiftyChronoX",
            targets: ["SwiftyChronoX"]
        ),
    ],
    targets: [
        .target(
            name: "SwiftyChronoX",
            path: "Sources"
        ),
        .testTarget(
            name: "SwiftyChronoXTests",
            dependencies: ["SwiftyChronoX"],
            path: "Tests/SwiftyChronoTests",
            resources: [],
            linkerSettings: [
                .linkedFramework("JavaScriptCore"),
            ]
        ),
    ]
)
