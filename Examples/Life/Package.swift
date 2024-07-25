// swift-tools-version: 5.9

import PackageDescription

// TODO: Give this variable a better name both for the code and the enviroment variable.
guard let gccIncludePrefix = Context.environment["GCC_ARM_PLAYDATE_PATH"] else {
  fatalError("Make sure you have the GCC_ARM_PLAYDATE_PATH variable defined.")
}

guard let playdate_sdk_path = Context.environment["PLAYDATE_SDK_PATH"] else {
  fatalError("Make sure you have the PLAYDATE_SDK_PATH variable defined.")
}

let swiftSettingsSimulator: [SwiftSetting] = [
  .enableExperimentalFeature("Embedded"),
  .unsafeFlags([
    "-Xfrontend", "-disable-objc-interop",
    "-Xfrontend", "-disable-stack-protector",
    "-Xfrontend", "-function-sections",
    "-Xfrontend", "-gline-tables-only",
    "-Xcc", "-DTARGET_EXTENSION",
    "-Xcc", "-I", "-Xcc", "\(gccIncludePrefix)/include",
    "-Xcc", "-I", "-Xcc", "\(gccIncludePrefix)/include-fixed",
    "-Xcc", "-I", "-Xcc", "\(gccIncludePrefix)/../../../../arm-none-eabi/include",
    "-I", "\(playdate_sdk_path)/C_API",
  ]),
]

let package = Package(
  name: "Life",
  products: [
    .library(name: "Life", targets: ["Life"])
  ],
  dependencies: [
    .package(path: "../..")
  ],
  targets: [
    .target(
      name: "Life",
      dependencies: [
        .product(name: "Playdate", package: "swift-playdate-examples")
      ],
      swiftSettings: swiftSettingsSimulator)
  ],
  swiftLanguageVersions: [.version("6"), .v5])
