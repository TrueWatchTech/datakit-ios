// swift-tools-version: 5.9

//  Copyright 2026 TRUEWATCH TECHNOLOGY INC PTE. LTD.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import PackageDescription

let package = Package(
    name: "OrbitDeskNativeHost",
    platforms: [.macOS(.v13)],
    products: [
        .executable(
            name: "OrbitDeskNativeHost",
            targets: ["OrbitDeskNativeHost"]
        ),
    ],
    dependencies: [
        .package(
            name: "datakit-ios",
            path: "../../../../.."
        ),
    ],
    targets: [
        .executableTarget(
            name: "OrbitDeskNativeHost",
            dependencies: [
                .product(name: "TrueWatchSDK", package: "datakit-ios"),
                .product(name: "TrueWatchSessionReplay", package: "datakit-ios"),
                .product(name: "TrueWatchElectronWebView", package: "datakit-ios"),
            ],
            path: "Sources/OrbitDeskNativeHost",
            linkerSettings: [
                .linkedFramework("AppKit"),
            ]
        ),
        .testTarget(
            name: "OrbitDeskNativeHostTests",
            dependencies: ["OrbitDeskNativeHost"],
            path: "Tests/OrbitDeskNativeHostTests"
        ),
    ]
)
