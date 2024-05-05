# Swift Playdate Examples

A technical demonstration of Embedded Swift running on Playdate by Panic

| **CI Status** |
|---|
|[![SwiftPM Build](https://github.com/apple/swift-playdate-examples/actions/workflows/swiftpm.yml/badge.svg)](https://github.com/apple/swift-playdate-examples/actions/workflows/swiftpm.yml)|

## Why Swift for Playdate

The [Playdate](https://play.date) is a tiny handheld gaming console developed by [Panic](https://panic.com) featuring a Cortex M7 processor and a 400 by 240 1-bit display. Panic provides an SDK for building Playdate games in both C and Lua and is equipped with a Playdate Simulator. 

Most Playdate games are traditionally written in Lua for ease of development, but can run into performance problems that necessitate the added complexity of using C.

Embedded Swift solves this problem by pairing high-level ergonomics with low-level performance, while also providing memory safety guarantees which improve productivity and eliminate a common source of bugs. 

## Getting Started

To start using Swift with the Playdate SDK, you can find guides, articles, and API documentation via the [Package's documentation on the Web][docs] or in Xcode.

- [Exploring the Examples](https://apple.github.io/swift-playdate-examples/documentation/playdate/exploringtheexamples)
- [Downloading the Tools](https://apple.github.io/swift-playdate-examples/documentation/playdate/downloadingthetools)
- [Building the Examples](https://apple.github.io/swift-playdate-examples/documentation/playdate/buildingtheexamples)
- [Creating Your Own Game](https://apple.github.io/swift-playdate-examples/documentation/playdate/creatingyourowngame)

> Disclaimer: The examples included in this repository are not reference implementations for creating games.

[docs]: https://apple.github.io/swift-playdate-examples/documentation/playdate

## Contributing to Swift Playdate Examples

This repo is intended to demonstrate use of Embedded Swift on different platforms, using the Playdate as an example. PRs demonstrating ways to adapt Swift's language or tooling to this platform are welcome. It is not intended to be a full-featured Playdate SDK so please do not raise PRs to extend the Playdate Swift overlay to new areas.

### Code of Conduct

Like all Swift.org projects, we would like the Swift Playdate Examples project to foster a diverse and friendly community. We expect contributors to adhere the [Swift.org Code of Conduct](https://swift.org/code-of-conduct/). A copy of this document is [available in this repository][coc].

[coc]: CODE_OF_CONDUCT.md

### Contact information

The current code owner of this package is Rauhul Varma ([@rauhul](https://github.com/rauhul)). You can contact him [on the Swift forums](https://forums.swift.org/u/rauhul/summary).

In case of moderation issues, you can also directly contact a member of the [Swift Core Team](https://swift.org/community/#community-structure).
