// swift-tools-version: 5.9

import PackageDescription

let gccIncludePrefix =
  "/usr/local/playdate/gcc-arm-none-eabi-9-2019-q4-major/lib/gcc/arm-none-eabi/9.2.1"
guard let home = Context.environment["HOME"] else {
  fatalError("could not determine home directory")
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
    "-I", "\(home)/Developer/PlaydateSDK/C_API",
  ]),
]

let package = Package(
  name: "SwiftBreak",
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
