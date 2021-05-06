// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "AcknowledgementGenerator",
  platforms: [ .macOS(.v10_15) ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-argument-parser", from: "0.4.3"),
    .package(name: "Mustache", url: "https://github.com/groue/GRMustache.swift", from: "4.0.1")
  ],
  targets: [
    // Targets are the basic building blocks of a package. A target can define a module or a test suite.
    // Targets can depend on other targets in this package, and on products in packages this package depends on.
    .target(
      name: "AcknowledgementGenerator",
      dependencies: [
        "Mustache",
        .product(name: "ArgumentParser", package: "swift-argument-parser"),
      ]),
    .testTarget(
      name: "AcknowledgementGeneratorTests",
      dependencies: ["AcknowledgementGenerator"]),
  ]
)
