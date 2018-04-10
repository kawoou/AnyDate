// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "AnyDate",
    products: [
        .library(name: "AnyDate", targets: ["AnyDate"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "AnyDate",
            dependencies: []
        ),
        .testTarget(
            name: "AnyDateTests",
            dependencies: []
        )
    ],
    swiftLanguageVersions: [3, 4]
)