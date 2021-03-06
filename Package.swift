// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Index",
    platforms: [
        .macOS(.v10_12),
        .iOS(.v10)
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(name: "Index", targets: ["Index"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/ReactiveX/RxSwift", .upToNextMajor(from: "5.0.0")),
        .package(url: "https://github.com/umobi/UMUtils", .upToNextMajor(from: "1.1.3")),
        .package(url: "https://github.com/umobi/UIContainer", from: "1.2.0-beta"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "Index",
            dependencies: [
                "RxSwift", "UMUtils", "UIContainer",
                .product(name: "RxCocoa", package: "RxSwift")
            ]
        ),

        .testTarget(
            name: "IndexTests",
            dependencies: ["Index"]),
    ]
)
