// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "Axt",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "Axt",
            targets: ["Axt"]),
    ],
    targets: [
        .target(
            name: "Axt",
            dependencies: [],
            swiftSettings: [
                .define("TESTABLE", .when(configuration: .debug))
            ]),
    ]
)
