// swift-tools-version: 5.5

import PackageDescription

let package = Package(
    name: "TrueWatchSDKConsumerChecks",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
    ],
    products: [
        .executable(name: "ObjCConsumer", targets: ["ObjCConsumer"]),
        .executable(name: "SessionReplayObjCConsumer", targets: ["SessionReplayObjCConsumer"]),
        .executable(name: "SwiftConsumer", targets: ["SwiftConsumer"]),
        .executable(name: "SwiftUIConsumer", targets: ["SwiftUIConsumer"]),
    ],
    dependencies: [
        .package(path: "../.."),
    ],
    targets: [
        .executableTarget(
            name: "ObjCConsumer",
            dependencies: [
                .product(name: "TrueWatchSDK", package: "ft-sdk-ios"),
            ]
        ),
        .executableTarget(
            name: "SessionReplayObjCConsumer",
            dependencies: [
                .product(name: "TrueWatchSessionReplay", package: "ft-sdk-ios"),
            ]
        ),
        .executableTarget(
            name: "SwiftConsumer",
            dependencies: [
                .product(name: "TrueWatchSDK", package: "ft-sdk-ios"),
            ]
        ),
        .executableTarget(
            name: "SwiftUIConsumer",
            dependencies: [
                .product(name: "TrueWatchSDK", package: "ft-sdk-ios"),
            ]
        ),
    ]
)
