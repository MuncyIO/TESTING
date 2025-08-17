// swift-tools-version:6.1
import PackageDescription

let package = Package(
    name: "ReceiptApp",
    platforms: [
        .macOS(.v11)
    ],
    products: [
        .executable(name: "ReceiptApp", targets: ["ReceiptApp"])
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "ReceiptApp",
            dependencies: [],
            path: ".",
            sources: ["Sources", "Models/Receipt.swift", "Services", "Views"],
            resources: [
                .process("Models/ReceiptModel.xcdatamodeld")
            ]
        ),
        .testTarget(
            name: "ReceiptAppTests",
            dependencies: ["ReceiptApp"],
            path: "Tests"
        )
    ]
)
