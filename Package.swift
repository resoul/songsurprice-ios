// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "TabBar",
    platforms: [
        .tvOS(.v16)
    ],
    products: [
        .library(
            name: "TabBar",
            targets: ["TabBar"]
        ),
    ],
    targets: [
        .target(
            name: "TabBar",
            path: "Sources/TabBar"
        ),
    ]
)
