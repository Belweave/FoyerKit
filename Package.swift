// swift-tools-version: 6.3

//===--- Package.swift - FoyerKit -----------------------------------------===//
//
// This source file is part of FoyerKit, a belweave open source project.
//
// Copyright (c) 2026 belweave (Preetham Kyanam)
// Portions derived from an Apache 2.0 licensed project; its
// original copyright and attribution notices are kept in NOTICE.
// Copyright (c) 2026 Jiaxu Li
// Modified by belweave, 2026: renamed and changed; see CHANGES.md.
// Licensed under the Apache License, Version 2.0
//
// See LICENSE for license information
//
//===----------------------------------------------------------------------===//

import PackageDescription

let package = Package(
    name: "FoyerKit",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
    ],
    products: [
        .library(name: "FoyerKit", targets: ["FoyerKit"]),
    ],
    targets: [
        .target(
            name: "FoyerKit",
            resources: [
                .process("Resources"),
            ],
            swiftSettings: [
                .defaultIsolation(MainActor.self),
            ]
        ),
        .testTarget(
            name: "FoyerKitTests",
            dependencies: ["FoyerKit"],
            swiftSettings: [
                .defaultIsolation(MainActor.self),
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)
