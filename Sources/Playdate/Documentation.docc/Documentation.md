# ``Playdate``

@Metadata {
  @DisplayName("Swift Playdate Examples")
}

A technical demonstration of Embedded Swift running on Playdate by Panic.

## Why Swift for Playdate

The [Playdate](https://play.date) is a tiny handheld gaming console developed by [Panic](https://panic.com), featuring a Cortex M7 processor and a 400 by 240 1-bit display. Panic provides an SDK for building Playdate games in both C and Lua and is equipped with a Playdate Simulator. 

Most Playdate games are traditionally written in Lua for ease of development, but can run into performance problems that necessitate the added complexity of using C.

Embedded Swift solves this problem by pairing high-level ergonomics with low-level performance, while also providing memory safety guarantees that improve productivity and eliminate a common source of bugs. 

## Get Started

To build and run the Swift Playdate examples included in this repository, you'll need some additional tools. Specifically, you need a recent Swift nightly toolchain (built on 3/7/24 or later) and a copy of the Playdate SDK. For instructions on setting up your development environment, see <doc:DownloadingTheTools>.

The examples in this repository can be built using various build systems and IDEs for both the simulator and device. See <doc:BuildingTheExamples> for detailed instructions. See <doc:ExploringTheExamples> for descriptions and videos of the examples.

Once you have an example running on the Playdate Simulator, consult the Playdate documentation on [Uploading games from the Simulator](https://help.play.date/manual/simulator/#uploading-games-from-the-simulator) for guidance on running the example on a real device.

If you're interesting in creating your own games, detailed instructions on setting up a new example can be found at <doc:CreatingYourOwnGame>.
 
> Important: The Swift Playdate examples have only been tested on macOS host machines.

## Example Playdate Swift Overlay

This repository includes an example partial Playdate Swift overlay of the Playdate C API, under `Sources/Playdate`. The purpose of this overlay is to demonstrate how C APIs can be bridged to idiomatic Swift. However, the C APIs can also be used directly, without this overlay.

For additional API references and resources on building games, refer to the [Playdate developer site](https://play.date/dev/links).

## Topics

### Articles

- <doc:DownloadingTheTools>
- <doc:BuildingTheExamples>
- <doc:ExploringTheExamples>
- <doc:CreatingYourOwnGame>

### Essentials

- ``Display``
- ``Graphics``
- ``Sprite``
- ``System``
