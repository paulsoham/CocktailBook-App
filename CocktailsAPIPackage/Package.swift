// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CocktailsAPI",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "CocktailsAPI",
            targets: ["CocktailsAPI"]),
    ],
    targets: [
        .target(
            name: "CocktailsAPI",
            resources: [
                .process("Sources/CocktailsAPI/Resources/sample.json")
            ]
        ),
        .testTarget(
            name: "CocktailsAPITests",
            dependencies: ["CocktailsAPI"]),
    ]
)
