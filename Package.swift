// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "SwiftTestReporter",
    products: [
        .library(name: "SwiftTestReporter", targets: ["SwiftTestReporter"]),
    ],
    dependencies: [
        .package(url: "https://github.com/alexaubry/HTMLString.git", .upToNextMajor(from: "4.0.2")),
    ],
    targets: [
        .target(name: "SwiftTestReporter", dependencies: [ "HTMLString" ]),
        .testTarget(name: "SwiftTestReporterTests", dependencies: ["SwiftTestReporter"]),
    ]
)
