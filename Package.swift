// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "SwiftTestReporter",
    products: [
        .library(name: "SwiftTestReporter", targets: ["SwiftTestReporter"]),
    ],
    targets: [
        .target(name: "SwiftTestReporter"),
        .testTarget(name: "SwiftTestReporterTests", dependencies: ["SwiftTestReporter"]),
    ]
)
