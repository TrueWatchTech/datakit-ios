// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TrueWatchSDK",
    platforms: [
        .iOS(.v12),
        .macOS(.v10_14),
        .tvOS(.v12),
    ],
    products: [
        .library(
            name: "TrueWatchSDK",
            targets: [
                "TrueWatchSDK",
                "TrueWatchSDKSwiftUI",
            ]
        ),
        .library(
            name: "TrueWatchWidgetExtension",
            targets: ["TrueWatchWidgetExtension"]
        ),
        .library(
            name: "TrueWatchSessionReplay",
            targets: [
                "TrueWatchSessionReplay",
                "TrueWatchSessionReplaySwiftUI",
            ]
        ),
    ],
    dependencies: [],
    targets: [
        // MARK: - TrueWatchSDK
        .target(
            name: "TrueWatchSDK",
            dependencies: [
                "_TrueWatchSDKObjC",
                "TrueWatchSDKSwiftUI",
            ],
            path: "Sources/SwiftPM",
            sources: ["TrueWatchSDK.swift"]
        ),
        .target(
            name: "_TrueWatchSDKObjC",
            dependencies: [
                "_TrueWatchSDKCore",
                "_AgentExtension",
                "_AgentExternalData",
                "_AgentConfig",
                "TrueWatchSDKSwiftUI",
            ],
            path: "Sources",
            sources: [
                "Agent/Core",
                "Agent/AutoTrack",
            ],
            publicHeadersPath: "Agent/Core",
            cSettings: [
                .headerSearchPath("Agent/Core"),
                .headerSearchPath("Agent/AutoTrack"),
                .headerSearchPath("Core/DataFilter")
            ]
        ),
        .target(
            name: "TrueWatchSDKSwiftUI",
            path: "Sources/Agent/SwiftUI"
        ),
        .target(
            name: "_AgentConfig",
            dependencies: [
                "_FTBaseUtils_Base",
                "_FTRUM",
                "_FTProtocol",
            ],
            path: "Sources/Agent",
            sources: ["Config"],
            publicHeadersPath: "Config"
        ),
        .target(
            name: "_AgentExternalData",
            dependencies: [
                "_FTProtocol",
                "_FTBaseUtils_Base",
            ],
            path: "Sources/Agent/ExternalData",
            publicHeadersPath: "."
        ),
        .target(
            name: "_FTProtocol",
            dependencies: [],
            path: "Sources/Core/Protocol",
            publicHeadersPath: "."
        ),
        .target(
            name: "_FTRUM",
            dependencies: [
                "_FTBaseUtils_Base",
                "_FTBaseUtils_Thread",
                "_FTProtocol",
            ],
            path: "Sources/Core/FTRUM",
            cSettings: [
                .headerSearchPath("Monitor"),
                .headerSearchPath("FTCrash"),
                .headerSearchPath("FTCrash/RecordingCore"),
                .headerSearchPath("FTCrash/Recording"),
                .headerSearchPath("FTCrash/Recording/Monitors"),
                .headerSearchPath("RUMCore")
            ]
        ),
        .target(
            name: "_FTURLSessionAutoInstrumentation",
            dependencies: [
                "_FTProtocol",
                "_FTBaseUtils_Swizzle",
            ],
            path: "Sources/Core/URLSessionAutoInstrumentation",
            publicHeadersPath: "."
        ),
        .target(
            name: "_FTLogger",
            dependencies: [
                "_FTBaseUtils_Base",
                "_FTProtocol",
            ],
            path: "Sources/Core/Logger",
            publicHeadersPath: "."
        ),

        // MARK: - BaseUtils
        .target(
            name: "_FTBaseUtils_Base",
            dependencies: ["_FTBaseUtils_Thread"],
            path: "Sources/Core/BaseUtils/Base",
            publicHeadersPath: "."
        ),
        .target(
            name: "_FTBaseUtils_Swizzle",
            dependencies: ["_FTBaseUtils_Base"],
            path: "Sources/Core/BaseUtils/Swizzle",
            publicHeadersPath: "."
        ),
        .target(
            name: "_FTBaseUtils_Thread",
            path: "Sources/Core/BaseUtils/Thread"
        ),

        // MARK: - TrueWatchWidgetExtension
        .target(
            name: "_AgentExtension",
            dependencies: ["_FTBaseUtils_Base"],
            path: "Sources/Agent/Extension",
            publicHeadersPath: "."
        ),
        .target(
            name: "TrueWatchWidgetExtension",
            dependencies: [
                "_AgentExtension",
                "_FTRUM",
                "_FTURLSessionAutoInstrumentation",
                "_AgentExternalData",
                "_FTLogger",
                "_AgentConfig",
            ],
            path: "Sources/WidgetExtension",
            resources: [
                .copy("../Resources/PrivacyInfo.xcprivacy"),
            ],
            publicHeadersPath: "."
        ),

        // MARK: - TrueWatchSDKCore
        .target(
            name: "_TrueWatchSDKCore",
            dependencies: [
                "_FTRUM",
                "_FTURLSessionAutoInstrumentation",
                "_FTLogger",
            ],
            path: "Sources",
            sources: [
                "Core/FTWKWebView",
                "Core/DataManager",
                "Core/RemoteConfig",
                "Core/DataFilter",
            ],
            resources: [
                .copy("Resources/PrivacyInfo.xcprivacy"),
            ],
            publicHeadersPath: "Core/include",
            cSettings: [
                .headerSearchPath("Core/DataManager/Upload"),
                .headerSearchPath("Core/DataManager/Storage"),
                .headerSearchPath("Core/DataManager/Storage/fmdb"),
                .headerSearchPath("Core/FTWKWebView/JSBridge"),
                .headerSearchPath("Core/DataFilter"),
            ]
        ),

        // MARK: - TrueWatchSessionReplay
        .target(
            name: "TrueWatchSessionReplay",
            dependencies: ["_TrueWatchSDKCore"],
            path: "Sources/SessionReplay",
            exclude: [
                "Recorder/SRWireframe/ViewTreeSnapshot/ViewsRecorder/SwiftUI",
            ],
            publicHeadersPath: "Public",
            cSettings: [
                .headerSearchPath("../.."),
                .headerSearchPath("."),
                .headerSearchPath("Processor/Builders"),
                .headerSearchPath("DataStore"),
                .headerSearchPath("Recorder"),
                .headerSearchPath("Recorder/Touch"),
                .headerSearchPath("Recorder/SRWireframe"),
                .headerSearchPath("Recorder/SRWireframe/ViewTreeSnapshot"),
                .headerSearchPath("Recorder/SRWireframe/ViewTreeSnapshot/ViewsRecorder"),
                .headerSearchPath("Recorder/ScreenChangeMonitor"),
                .headerSearchPath("Storage"),
                .headerSearchPath("Storage/Writer"),
                .headerSearchPath("Storage/Reader"),
                .headerSearchPath("Storage/TmpCache"),
                .headerSearchPath("TLV"),
                .headerSearchPath("Upload"),
                .headerSearchPath("Upload/Request"),
                .headerSearchPath("Utilities"),
            ]
        ),
        .target(
            name: "TrueWatchSessionReplaySwiftUI",
            path: "Sources/SessionReplay/Recorder/SRWireframe/ViewTreeSnapshot/ViewsRecorder/SwiftUI"
        ),
    ]
)
