// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "filesize",
    dependencies: [
        .package(url: "https://github.com/Quick/Quick.git", from:"1.2.0"),
        .package(url: "https://github.com/Quick/Nimble.git", from:"7.0.3"),
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
