# Building the Examples

Build the examples with your favorite editor and tools.

## Overview

Each example in this repository contains a `Makefile` and `Package.swift`. The `Makefile` is _always_ used to perform the final build, but the `Package.swift` can be used to improve the development experience.

The examples' Makefiles depend on two supporting Makefiles for common logic. The first is `common.mk`, provided by the Playdate SDK, which includes rules for compiling/linking C source code and packaging object files into playdate-executable (pdx) files. The second is `swift.mk`, provided by this repository, includes rules and flags for compiling Swift source code.

`swift.mk` uses the `xcrun` executable, the `TOOLCHAINS` environment variable, and other tools from the Playdate SDK to select a Swift compiler (`swiftc`) executable and determine compiler flags needed to target both the Playdate Simulator and device.

> Paths:
> - `common.mk: $HOME/Developer/PlaydateSDK/C_API/buildsupport/common.mk`
> - `swift.mk: $REPO_ROOT/Examples/swift.mk`

### Build with Make

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

### Build with Nova

> Prerequisites: Install Nova, the Playdate extension, and the Icarus extension.

The examples included in this repository have been preconfigured with Panic's Playdate extension for Nova found under each example's `.nova` directory.

Open an example directory with Nova and select the Run icon in the toolbar or press Cmd+R on your keyboard to start a build. After a successful build, Nova will automatically open the Simulator with the newly built game.

@Image(source: "nova-build-success", alt: "A screenshot of Nova after a build has completed successfully.")

> Note: Learn more about [Nova](https://nova.app)

### Build with VSCode

> Prerequisites: Install VSCode and the Swift extension.

The examples included in this repository have been preconfigured with VSCode `tasks.json` files found under each example's `.vscode` directory.

Open an example directory with VSCode and select the Terminal > Run Build Task menu item or press Cmd+Shift+B on your keyboard to start a build. After a successful build, VSCode will automatically open the Simulator with the newly built game.

@Image(source: "vscode-build-success", alt: "A screenshot of VSCode after a build has completed successfully.")

> Note: Learn more about [VSCode](https://code.visualstudio.com)

### Build with Swift Package Manager

To build an example with swift package manager, enter the example’s directory, set the TOOLCHAINS environment variable to the name of your Swift nightly toolchain, and run `swift build` in release mode.

```console
$ cd $REPO_ROOT/Example/Life
$ TOOLCHAINS="org.swift.59202312211a" swift build -c release
```

After a successful build, the `.build/release` directory will contain object files for the host machine. While these objects be cannot by directly packaged into a pdx, it is a good indication that the build will also succeed with `make`.

> Note: Learn more about [Swift Package Manager](https://www.swift.org/package-manager/)

### Build with Xcode

> IMPORTANT:
> Xcode 15.3+ is required to run the examples in Xcode.

Open an example's `Package.swift` with Xcode via the command line or the Xcode graphical interface.

```console
$ cd Examples/Life
$ open Package.swift
```

Select your Swift nightly toolchain from the Xcode > Toolchains menu item.

@Image(source: "xcode-toolchain-selection", alt: "A screenshot of the Xcode toolchain selection menu with a recent Swift nightly toolchain selected and highlighted.")

Select the Run icon in the toolbar or press Cmd+R on your keyboard to start a build. This will first build the example for the host machine using `xcbuild`. After a successful initial build, Xcode will automatically build again with `make` then open the Simulator with the newly built game.

> Note:
> Learn more about [Xcode](https://developer.apple.com/xcode/)
