# Building the Examples

Build the examples with your favorite editor and tools.

## Overview

Each example in this repository contains a `Makefile` and `Package.swift`. The `Makefile` is _always_ used to perform the final build, but the `Package.swift` can be used to improve the development experience.

The examples' Makefiles depend on two supporting Makefiles for common logic. The first is `common.mk`, provided by the Playdate SDK, which includes rules for compiling/linking C source code and packaging object files into playdate-executable (pdx) files. The second is `swift.mk`, provided by this repository, includes rules and flags for compiling Swift source code.

`swift.mk` uses the `xcrun` executable, the `TOOLCHAINS` environment variable, and other tools from the Playdate SDK to select a Swift compiler (`swiftc`) executable and determine compiler flags needed to target both the Playdate Simulator and device.

> Paths:
> - `common.mk: $HOME/Developer/PlaydateSDK/C_API/buildsupport/common.mk`
> - `swift.mk: $REPO_ROOT/Examples/swift.mk`

## Build with Make

To build an example with make, enter the example's directory and run `make`.

```console
$ cd $REPO_ROOT/Example/Life
$ make
```

After the build completes, the example directory will include a pdx file which can be run on the Playdate Simulator and device. To run the game on the simulator, launch the "Playdate Simulator.app" included in the Playdate SDK and open the game using the File > Open menu item.

@Image(source: "playdate-simulator-open", alt: "A screenshot of the Playdate Simulator's open file dialog box, with Life.pdx selected.")

Alternatively, the game can be run by launching the simulator executable with the pdx file as the first argument on the command line.

```console
$ cd $REPO_ROOT/Example/Life
$ $HOME/Developer/PlaydateSDK/bin/Playdate\ Simulator.app/Contents/MacOS/Playdate\ Simulator Life.pdx
```

> Note: Learn more about [`make`](https://man.freebsd.org/cgi/man.cgi?make(1))

## Build with Nova

Prerequisites: Install Nova, the Playdate extension, and the Icarus extension.

### Configure the Icarus extension

Configure the Icarus Swift language support extension to use a Swift nightly toolchain. See <doc:DownloadingTheTools> for instructions on how to install a nightly toolchain.

Use the Menu bar to navigate to the extension library Extension > Extension Library or press Cmd+Shift+2. Select the Icarus extension, then select the Settings panel. Finally, select the "Toolchain: Custom" option and provide a full path to your nightly toolchain in the "Custom Toolchain Path" field.

@Image(source: "nova-icarus-configuration", alt: "A screenshot of the Icarus extension settings in Nova with \"Custom\" selected.")

> Note: This path should end in `.xctoolchain`.

### Make the Playdate module available

Icarus uses the `Playdate.swiftmodule` built by SwiftPM to drive autocomplete and other editor integration. In order for this to work properly, you must first manually perform a release build in the example directory.

```console
$ cd $REPO_ROOT/Example/Life
$ TOOLCHAINS="org.swift.59202312211a" swift build -c release
```

Lastly, we need to create a debug symlink the release build directory.

```console
$ cd $REPO_ROOT/Example/Life/.build/arm64-apple-macosx
$ ln -s release debug
```

> Why is this needed? By default SourceKit-LSP looks for a debug build, but can be configured to use a release build. Unfortunately, Icarus does not yet allow us to pass custom SourceKit-LSP options, so we trick SourceKit-LSP into working by pretending our release build is a debug build.

### Perform a Build

The examples included in this repository have been preconfigured with Panic's Playdate extension for Nova found under each example's `.nova` directory.

Open an example directory with Nova and select the Run icon in the toolbar or press Cmd+R on your keyboard to start a build. After a successful build, Nova will automatically open the Simulator with the newly built game.

@Image(source: "nova-build-success", alt: "A screenshot of Nova after a build has completed successfully.")

> Note: Learn more about [Nova](https://nova.app)

## Build with VSCode

Prerequisites: Install VSCode and the Swift extension.

### Configure the Swift extension

Configure the VSCode Swift extension to use a Swift nightly toolchain. See <doc:DownloadingTheTools> for instructions on how to install a nightly toolchain.

Under the Swift Settings, select the "Swift: Path" option and provide a full path to the `usr/bin` folder inside your nightly toolchain.

@Image(source: "vscode-swift-path-configuration", alt: "A screenshot of VSCode Swift extension with the \"Swift: Path\" option set to \"/Library/Developer/Toolchains/swift-DEVELOPMENT-SNAPSHOT-2024-03-07-a.xctoolchain/usr/bin\".")

Under the Swift Settings, select the "Swift > Sourcekit-LSP: Server Arguments" option and pass the arguments `['--configuration', 'release']`.

@Image(source: "vscode-sourcekit-lsp-configuration", alt: "A screenshot of VSCode Swift extension with the \"Swift > Sourcekit-LSP: Server Arguments\" option set to \"['--configuration', 'release']\".")

### Make the Playdate module available

The Swift extension uses the `Playdate.swiftmodule` built by SwiftPM to drive autocomplete and other editor integration. In order for this to work properly, you must first manually perform a release build in the example directory.

```console
$ cd $REPO_ROOT/Example/Life
$ TOOLCHAINS="org.swift.59202312211a" swift build -c release
```

### Perform a Build

The examples included in this repository have been preconfigured with VSCode `tasks.json` files found under each example's `.vscode` directory.

Open an example directory with VSCode and select the Terminal > Run Build Task menu item or press Cmd+Shift+B on your keyboard to start a build. After a successful build, VSCode will automatically open the Simulator with the newly built game.

@Image(source: "vscode-build-success", alt: "A screenshot of VSCode after a build has completed successfully.")

> Note: Learn more about [VSCode](https://code.visualstudio.com)

## Build with Swift Package Manager

To build an example with swift package manager, enter the example’s directory, set the TOOLCHAINS environment variable to the name of your Swift nightly toolchain, and run `swift build` in release mode.

```console
$ cd $REPO_ROOT/Example/Life
$ TOOLCHAINS="org.swift.59202312211a" swift build -c release
```

After a successful build, the `.build/release` directory will contain object files for the host machine. While these objects be cannot by directly packaged into a pdx, it is a good indication that the build will also succeed with `make`.

> Note: Learn more about [Swift Package Manager](https://www.swift.org/package-manager/)

## Build with Xcode

> Important: Xcode 15.3+ is required to run the examples in Xcode.

Open an example's `Package.swift` with Xcode via the command line or the Xcode graphical interface.

```console
$ cd Examples/Life
$ open Package.swift
```

### Configure the Toolchain

Select your Swift nightly toolchain from the Xcode > Toolchains menu item.

@Image(source: "xcode-toolchain-selection", alt: "A screenshot of the Xcode toolchain selection menu with a recent Swift nightly toolchain selected and highlighted.")

### Perform a Build

Select the Run icon in the toolbar or press Cmd+R on your keyboard to start a build. This will first build the example for the host machine using `xcbuild`. After a successful initial build, Xcode will automatically build again with `make` then open the Simulator with the newly built game.

> Note: Learn more about [Xcode](https://developer.apple.com/xcode/)
