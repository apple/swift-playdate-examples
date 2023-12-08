# Exploring the Examples

Learn about writing games by playing Conway's Game of Life and Swift Break.

## Conway's Game of Life

The simplest example in this repository is "Conway's Game of Life", a 0-player game/mathematical simulation. This Swift implementation is comparable to the C example provided in the Playdate SDK. It demonstrates a simple single file Swift game which compiles and links directly against the Playdate C API, and additionally does not require the use of an allocator.

The game starts with a random initial state, seeded based on the device's current time, and runs indefinitely, progressing one generation per frame. To reset the game to a new random state, users can press the 'A' button.

@Image(source: "playdate-simulator-still-life", alt: "A screenshot of the Playdate Simulator running “Conway’s Game of Life”.")

The packaged game is just 788 bytes, slightly smaller than the C example from the Playdate SDK which is 904 bytes.

```console
$ wc -c < $REPO_ROOT/Examples/Life/Life.pdx/pdex.bin
     788

$ wc -c < $HOME/Developer/PlaydateSDK/C_API/Examples/GameOfLife.pdx/pdex.bin
     904
```

See <doc:BuildingTheExamples> for instructions on how to build and run this example.

> Note: Learn more about [Conway's Game of Life](https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life)

## Swift Break

Another example in this repository is "Swift Break," a classic paddle-and-ball style game. It utilizes the sprite bitmap API to draw game elements such as the ball, paddle, bricks, background, and overlay screens and uses sprite collision API to implement the ball bouncing logic.

This example is built from scratch, referencing the [Playdate C API documentation](https://sdk.play.date/2.1.1/Inside%20Playdate%20with%20C.html) and using Adobe Photoshop for sprite design. Additionally, it leverages the provided Playdate Swift overlay within this repository to bridge the Playdate C API into more idiomatic Swift API.

SwiftBreak showcases how Embedded Swift's features, such as discriminated enums, generic type parameters, and automatic memory management, can enhance application development, offering a more ergonomic language experience while retaining the potential for C-level performance.
  
SwiftBreak includes features like a splash screen, a pause menu, paddle-location-based bounce physics, infinite levels (which are all the same), and a game over screen. Control the paddle by pressing the left or right buttons on the D-pad or by turning the crank. Press the 'B' button to pause the game.

@Image(source: "playdate-simulator-still-swiftbreak", alt: "A screenshot of the Playdate Simulator with the Swift Break splash screen.")

