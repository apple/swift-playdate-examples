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

let cSettingsSimulator: [CSetting] = [
  .unsafeFlags([
    "-DTARGET_EXTENSION",
    "-I", "\(gccIncludePrefix)/include",
    "-I", "\(gccIncludePrefix)/include-fixed",
    "-I", "\(gccIncludePrefix)/../../../../arm-none-eabi/include",
    "-I", "\(playdateSdkPath)/C_API",
  ])
]

let package = Package(
  name: "swift-playdate-examples",
  products: [
    .library(name: "Playdate", targets: ["Playdate"]),
    .library(name: "CPlaydate", targets: ["CPlaydate"]),
  ],
  targets: [
    .target(
      name: "Playdate",
      dependencies: ["CPlaydate"],
      swiftSettings: swiftSettingsSimulator),
    .target(
      name: "CPlaydate",
      cSettings: cSettingsSimulator),
  ],
  swiftLanguageVersions: [.version("6"), .v5])
