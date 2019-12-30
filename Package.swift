// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "ReadabilityKit",
    platforms: [
        .macOS(.v10_12),
        .iOS(.v10),
        .watchOS(v3),
        .tvOS(.v10)
    ],
    products: [
        .library(
            name: "ReadabilityKit", 
            targets: ["ReadabilityKit"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/honghaoz/Ji",
            from: "5.0.0"
        )
    ],
    targets: [
        .target(
            name: "ReadabilityKit",
            dependencies: ["Ji"],
            path: "Sources"
        ),
        .testTarget(
            name: "ReadabilityKitTests",
            dependencies: ["ReadabilityKit"],
            path: "Tests"
        )
    ],
    swiftLanguageVersions: [.v5]
)
