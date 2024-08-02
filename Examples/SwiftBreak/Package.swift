// swift-tools-version: 5.9

import PackageDescription

guard let gccIncludePrefix = Context.environment["GCC_ARM_INCLUDE_PREFIX_PATH"] else {
  fatalError("Make sure you have the GCC_ARM_INCLUDE_PREFIX_PATH variable defined.")
}

guard let playdateSdkPath = Context.environment["PLAYDATE_SDK_PATH"] else {
  fatalError("Make sure you have the PLAYDATE_SDK_PATH variable defined.")
}

let swiftSettingsSimulator: [SwiftSetting] = [
  .enableExperimentalFeature("Embedded"),
  .enableExperimentalFeature("NoncopyableGenerics"),
  .unsafeFlags([
    "-Xfrontend", "-disable-objc-interop",
    "-Xfrontend", "-disable-stack-protector",
    "-Xfrontend", "-function-sections",
    "-Xfrontend", "-gline-tables-only",
    "-Xcc", "-DTARGET_EXTENSION",
    "-Xcc", "-I", "-Xcc", "\(gccIncludePrefix)/include",
    "-Xcc", "-I", "-Xcc", "\(gccIncludePrefix)/include-fixed",
    "-Xcc", "-I", "-Xcc", "\(gccIncludePrefix)/../../../../arm-none-eabi/include",
    "-I", "\(playdateSdkPath)/C_API",
  ]),
]

let package = Package(
  name: "SwiftBreak",
  platforms: [
    .macOS(.v14)
  ],
  products: [
    .library(name: "SwiftBreak", targets: ["SwiftBreak"])
  ],
  dependencies: [
    .package(path: "../..")
  ],
  targets: [
    .target(
      name: "SwiftBreak",
      dependencies: [
        .product(name: "Playdate", package: "swift-playdate-examples")
      ],
      swiftSettings: swiftSettingsSimulator)
  ],
  swiftLanguageVersions: [.version("6"), .v5])
