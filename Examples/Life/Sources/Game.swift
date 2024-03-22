//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift open source project
//
// Copyright (c) 2024 Apple Inc. and the Swift project authors.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
//
//===----------------------------------------------------------------------===//
//
// Game of Life
//
// Rules:
// - Any live cell with fewer than two live neighbors dies, as if caused by
//   under-population.
// - Any live cell with two or three live neighbors lives on to the next
//   generation.
// - Any live cell with more than three live neighbors dies, as if by
//   overcrowding.
// - Any dead cell with exactly three live neighbors becomes a live cell, as if
//   by reproduction.
//
//===----------------------------------------------------------------------===//

public import Playdate

infix operator %% : MultiplicationPrecedence

func %% (lhs: Int32, rhs: Int32) -> Int32 {
  let rem = lhs % rhs
  return rem >= 0 ? rem : rem + rhs
}

/// The "main" entry point for playdate games.
@_cdecl("eventHandler")
public func eventHandler(
  pointer: UnsafeMutableRawPointer!,
  event: PDSystemEvent,
  arg: UInt32
) -> Int32 {
  if event == .initialize {
    // Setup the Playdate API, this is required for functions like:
    // `Display.setRefreshRate(rate: 0)` to call into the correct Playdate
    // runtime function
    initializePlaydateAPI(with: pointer)

    // Configure the display to run as fast as our game can run (on the Playdate
    // simulator)
    Display.setRefreshRate(rate: 0)

    // Setup the `update` function below as the function to call on each game
    // runloop tick.
    System.setUpdateCallback(update: update, userdata: nil)

    // Set the initial frame to a random state.
    Frame.current.randomize()
  }
  return 0
}

/// The update function called on each runloop tick.
@_cdecl("update")
func update(pointer: UnsafeMutableRawPointer!) -> Int32 {
  let frameNext = Frame.next
  let frameCurrent = Frame.current

  // If the user presses "A" then randomize the screen.
  if System.buttonState.pushed == .a {
    frameCurrent.randomize()
  }

  // Update the next frame based on the current frame.
  frameNext.update(frameCurrent: frameCurrent)

  // Tell the Playdate runtime that we updated the frame buffer, so the runtime
  // knows to display the frame buffer on the screen.
  Graphics.markUpdatedRows(start: 0, end: Frame.rows)

  return 1
}

/// Playdate Frame
///
/// ```
/// (column: 0, row: 0)                    (column: LCD_COLUMNS, row: 0)
/// ╭──────────────────────────────────────────────────────────────────╮
/// │                                                                  │
/// │             SSSSS  CCCCC  RRRR   EEEEE  EEEEE  N   N             │
/// │             S      C      R   R  E      E      NN  N             │
/// │             SSSSS  C      RRRR   EEEEE  EEEEE  N N N             │
/// │                 S  C      R R    E      E      N  NN             │
/// │             SSSSS  CCCCC  R  R   EEEEE  EEEEE  N   N             │
/// │                                                                  │
/// ╰──────────────────────────────────────────────────────────────────╯
/// (column: 0, row: LCD_ROWS)      (column: LCD_COLUMNS, row: LCD_ROWS)
/// ```
struct Frame {
  static let rows = LCD_ROWS
  static let rowSize = LCD_ROWSIZE
  static let columns = LCD_COLUMNS

  /// The frame currently on screen.
  static var current: Self { Frame(buffer: Graphics.getDisplayFrame()!) }
  
  /// The frame to be displayed on the screen on the next update.
  static var next: Self { Frame(buffer: Graphics.getFrame()!) }

  /// The raw memory backing this frame, owned by the Playdate runtime.
  var buffer: UnsafeMutablePointer<UInt8>

  /// Returns a typed object representing a single row of the frame.
  subscript(row: Int32) -> Row {
    let index = Int(row * Self.rowSize)
    return Row(buffer: self.buffer.advanced(by: index))
  }

  /// Sets each pixel of the frame to a random value.
  func randomize() {
    for row in 0..<Self.rows {
      for column in 0..<(Self.columns / 8) {
        let index = Int((row * Self.rowSize) + column)
        self.buffer[index] = UInt8(rand() & 0xff)
      }
    }
  }

  /// Updates each pixel of this frame based on the values in the previous
  /// frame.
  @inline(__always)
  func update(frameCurrent: Frame) {
    var rowAbove = frameCurrent[Frame.rows - 1]
    var rowCurrent = frameCurrent[0]
    var rowBelow = frameCurrent[1]

    for row in 0..<Frame.rows {
      self[row].update(
        rowAbove: rowAbove,
        rowCurrent: rowCurrent,
        rowBelow: rowBelow)
      rowAbove = rowCurrent
      rowCurrent = rowBelow
      rowBelow = frameCurrent[(row + 2) %% Frame.rows]
    }
  }
}

/// A single line of a frame buffer.
struct Row {
  /// The raw memory backing this row, owned by the Playdate runtime.
  var buffer: UnsafeMutablePointer<UInt8>

  /// Convenience API for reading or mutating a byte (8 pixels) of the row.
  subscript(column: Int) -> UInt8 {
    get { self.buffer[column] }
    nonmutating set { self.buffer[column] = newValue }
  }

  // Returns the sum of the 3 pixels centered around the requested column.
  func sum(at column: Int32) -> Int32 {
    if column == 0 {
      return self.value(at: Frame.columns - 1)
        + self.value(at: column)
        + self.value(at: column + 1)
    } else if column < Frame.columns - 1 {
      return self.value(at: column - 1)
        + self.value(at: column)
        + self.value(at: column + 1)
    } else {
      return self.value(at: column - 1)
        + self.value(at: column)
        + self.value(at: 0)
    }
  }

  // Returns the sum of the 2 pixels to the left and right of the requested
  // column.
  func middleSum(at column: Int32) -> Int32 {
    if column == 0 {
      return self.value(at: Frame.columns - 1) + self.value(at: column + 1)
    } else if column < Frame.columns - 1 {
      return self.value(at: column - 1) + self.value(at: column + 1)
    } else {
      return self.value(at: column - 1) + self.value(at: 0)
    }
  }

  /// Returns the value of the pixel at the requested column.
  func value(at column: Int32) -> Int32 {
    self.isOn(at: column) ? 1 : 0
  }

  /// Returns `true` if the pixel at the requested column is "alive".
  ///
  /// Alive cell are represented by a 0 bit and dead cells a 1.
  func isOn(at column: Int32) -> Bool {
    let byte = self.buffer[Int(column / 8)]
    let bitPosition: UInt8 = 0x80 >> (column % 8)
    return (byte & bitPosition) == 0
  }

  /// Updates each pixel of this row based on the values of rows surrounding
  /// this row in the previous frame.
  @inline(__always)
  func update(rowAbove: Row, rowCurrent: Row, rowBelow: Row) {
    var byte: UInt8 = 0
    var bitPosition: UInt8 = 0x80
    for column in 0..<Frame.columns {
      // If total is 3 cell is alive
      // If total is 4, no change
      // Else, cell is dead
      let sum = rowAbove.sum(at: column)
        + rowCurrent.middleSum(at: column)
        + rowBelow.sum(at: column)

      if sum == 3 || (rowCurrent.isOn(at: column) && sum == 2) {
        byte |= bitPosition
      }

      bitPosition >>= 1

      if bitPosition == 0 {
        self[Int(column / 8)] = ~byte
        byte = 0
        bitPosition = 0x80
      }
    }
  }
}
