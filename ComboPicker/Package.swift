// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "ComboPicker",
    platforms: [
      .iOS(.v15),
      .macOS(.v12),
      .watchOS(.v8),
      .tvOS(.v15)
    ],
    products: [
        .library(
            name: "ComboPicker",
            targets: ["ComboPicker"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "ComboPicker",
            dependencies: []),
        .testTarget(
            name: "ComboPickerTests",
            dependencies: ["ComboPicker"]),
    ]
)
