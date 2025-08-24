// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftRipple",
    platforms: [.iOS(.v13),.macOS(.v10_15),.tvOS(.v13),.visionOS(.v1), .watchOS(.v8)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SwiftRipple",
            targets: ["SwiftRipple"]),
    ],
    dependencies: [.package(url: "https://github.com/richardjorne/AllTouchGestureModifier", branch: "main")]
    , targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SwiftRipple",dependencies: ["AllTouchGestureModifier"]),
        
    ]
)
