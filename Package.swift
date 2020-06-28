// swift-tools-version:5.3

import PackageDescription

let sparkleBundleIdentifier = "org.sparkle-project.Sparkle"

let cSettings: [CSetting] = [
    .define("SPARKLE_BUNDLE_IDENTIFIER", to: "\"\(sparkleBundleIdentifier)\""),
    .define("SPARKLE_NORMALIZE_INSTALLED_APPLICATION_NAME", to: "0"),
    .define("SPARKLE_APPEND_VERSION_NUMBER", to: "1"),
    .define("SPARKLE_AUTOMATED_DOWNGRADES", to: "0"),
    .define("SPARKLE_RELAUNCH_TOOL_NAME", to: "\"Autoupdate\""),
    .define("SPARKLE_FILEOP_TOOL_NAME", to: "\"fileop\"")
]

let package = Package(
    name: "Sparkle",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v10_10)
    ],
    products: [
        .library(
            name: "Sparkle",
            targets: ["Sparkle"]
        ),
        .executable(
            name: "Autoupdate",
            targets: ["Autoupdate"]
        ),
        .executable(
            name: "BinaryDelta",
            targets: ["BinaryDelta"]
        ),
        .executable(
            name: "fileop",
            targets: ["fileop"]
        ),
        .executable(
            name: "generate_appcast",
            targets: ["generate_appcast"]
        ),
        .executable(
            name: "generate_keys",
            targets: ["generate_keys"]
        ),
        .executable(
            name: "sign_update",
            targets: ["sign_update"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Common",
            path: "Common",
            publicHeadersPath: ".",
            cSettings: cSettings
        ),
        .target(
            name: "Common UI",
            dependencies: ["Common"],
            path: "Sparkle/Common UI",
            resources: [
                .process("Resources/SUStatus.xib")
            ],
            publicHeadersPath: ".",
            cSettings: cSettings
        ),
        .target(
            name: "Sparkle",
            dependencies: [
                "Autoupdate",
                "ed25519",
                "Unarchiving"
            ],
            path: "Sparkle",
            exclude: [
                "Autoupdate",
                "CheckLocalizations.swift",
                "Common UI",
                "Installation",
                "Unarchiving"
            ],
            resources: [
                .copy("DarkAqua.css"),
                .process("Sparkle-Info.plist")
            ],
            cSettings: cSettings,
            linkerSettings: [
                .linkedLibrary("bz2"),
                .linkedLibrary("xar")
            ]
        ),
        .target(
            name: "Autoupdate",
            dependencies: [
                "Common UI",
                "fileop",
                "Installation"
            ],
            path: "Sparkle/Autoupdate",
            resources: [
                .process("Autoupdate-Info.plist"),
                .process("Resources/AppIcon.icns")
            ],
            cSettings: cSettings
        ),
        .target(
            name: "BinaryDelta",
            dependencies: [
                "Common",
                "Unarchiving"
            ],
            path: "BinaryDelta"
        ),
        .target(
            name: "Installation",
            dependencies: ["Common"],
            path: "Sparkle/Installation",
            publicHeadersPath: ".",
            cSettings: cSettings
        ),
        .target(
            name: "Unarchiving",
            dependencies: [
                "Common",
                "bsdiff"
            ],
            path: "Sparkle/Unarchiving",
            publicHeadersPath: ".",
            cSettings: cSettings,
            linkerSettings: [
                .linkedLibrary("xar")
            ]
        ),
        .target(
            name: "fileop",
            dependencies: ["Common"],
            path: "fileop"
        ),
        .target(
            name: "generate_appcast",
            dependencies: [
                "Common",
                "ed25519",
                "Unarchiving"
            ],
            path: "generate_appcast"
        ),
        .target(
            name: "generate_keys",
            dependencies: ["ed25519"],
            path: "generate_keys"
        ),
        .target(
            name: "sign_update",
            dependencies: ["ed25519"],
            path: "sign_update"
        ),
        .target(
            name: "bsdiff",
            path: "Vendor/bsdiff",
            publicHeadersPath: ".",
            linkerSettings: [
                .linkedLibrary("bz2")
            ]
        ),
        .target(
            name: "ed25519",
            path: "Vendor/ed25519",
            exclude: [
                "ed25519/test.c",
                "ed25519/license.txt",
                "ed25519/ed25519_32.dll",
                "ed25519/ed25519_64.dll",
                "ed25519/readme.md"
            ],
            sources: ["ed25519/src"]
        )
    ]
)
