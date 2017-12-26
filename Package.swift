// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "filesize",
    dependencies: [
    ],
    targets: [
        
        .target(
            name: "filesize",
            dependencies: ["filesizeCore"],
            path: "Sources/filesize"
        ),
        .target(
            name: "filesizeCore",
            dependencies: [],
            path: "Sources/filesizeCore"
        ),
        .testTarget(
            name: "filesizeTests",
            dependencies: ["filesizeCore"],
            path: "Tests"
        )
    ]
)
