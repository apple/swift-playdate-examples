// swift-tools-version: 5.9

import PackageDescription

let gccIncludePrefix =
  "/usr/local/playdate/gcc-arm-none-eabi-9-2019-q4-major/lib/gcc/arm-none-eabi/9.2.1"
guard let home = Context.environment["HOME"] else {
  fatalError("could not determine home directory")
}

let swiftSettingsSimulator: [SwiftSetting] = [
  .enableExperimentalFeature("Embedded"),
  .unsafeFlags([
    "-g", "-Onone",
    "-Xfrontend", "-Onone",
    "-Xfrontend", "-disable-objc-interop",
    "-Xfrontend", "-disable-stack-protector",
    "-Xfrontend", "-function-sections",
    // "-Xfrontend", "-gline-tables-only",
    "-Xcc", "-DTARGET_EXTENSION",
    "-Xcc", "-I", "-Xcc", "\(gccIncludePrefix)/include",
    "-Xcc", "-I", "-Xcc", "\(gccIncludePrefix)/include-fixed",
    "-Xcc", "-I", "-Xcc", "\(gccIncludePrefix)/../../../../arm-none-eabi/include",
    "-I", "\(home)/Developer/PlaydateSDK/C_API",
  ]),
]

let cSettingsSimulator: [CSetting] = [
  .unsafeFlags([
    "-DTARGET_EXTENSION",
    "-nostdlib",
    "-I", "\(gccIncludePrefix)/include",
    "-I", "\(gccIncludePrefix)/include-fixed",
    "-I", "\(gccIncludePrefix)/../../../../arm-none-eabi/include",
    "-I", "\(home)/Developer/PlaydateSDK/C_API",
  ])
]

let package = Package(
  name: "swift-playdate-examples",
  products: [
    .library(name: "Playdate", type: .static, targets: ["Playdate"]),
    .library(name: "CPlaydate", type: .static, targets: ["CPlaydate"]),
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
