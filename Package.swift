// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "LifeAdminCore",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "LifeAdminCore",
            targets: ["LifeAdminCore"]
        ),
        .executable(
            name: "LifeAdminDemo",
            targets: ["LifeAdminDemo"]
        ),
        .executable(
            name: "LifeAdminDesktop",
            targets: ["LifeAdminDesktop"]
        )
    ],
    targets: [
        .target(
            name: "LifeAdminCore"
        ),
        .executableTarget(
            name: "LifeAdminDemo",
            dependencies: ["LifeAdminCore"]
        ),
        .executableTarget(
            name: "LifeAdminDesktop",
            dependencies: ["LifeAdminCore"]
        ),
        .testTarget(
            name: "LifeAdminCoreTests",
            dependencies: ["LifeAdminCore"]
        )
    ]
)
