public import CPlaydate

infix operator %% : MultiplicationPrecedence
func %% (lhs: Int32, rhs: Int32) -> Int32 {
  let rem = lhs % rhs
  return rem >= 0 ? rem : rem + rhs
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
///
/// 1 -> white -> dead
/// 0 -> black -> alive
struct Frame {
  static let rows = LCD_ROWS
  static let rowSize = LCD_ROWSIZE
  static let columns = LCD_COLUMNS

  var buffer: UnsafeMutablePointer<UInt8>

  func randomize() {
    for row in 0..<Self.rows {
      for column in 0..<(Self.columns / 8) {
        let index = Int((row * Self.rowSize) + column)
        self.buffer[index] = UInt8(rand() & 0xff)
      }
    }
  }

  func row(_ row: Int32) -> Row {
    let row = row %% Self.rows
    let index = Int(row * Self.rowSize)
    return Row(buffer: self.buffer.advanced(by: index))
  }
}

struct Row {
  var buffer: UnsafeMutablePointer<UInt8>

  func sum(at column: Int32) -> UInt8 {
    self.middleSum(at: column) + self.value(at: column)
  }

  func middleSum(at column: Int32) -> UInt8 {
    let lower = (column - 1) %% Frame.columns
    let upper = (column + 1) %% Frame.columns
    return self.value(at: lower) + self.value(at: upper)
  }

  func value(at column: Int32) -> UInt8 {
    self.isOn(at: column) ? 1 : 0
  }

  func isOn(at column: Int32) -> Bool {
    let byte = self.buffer[Int(column / 8)]
    let bitPosition: UInt8 = 0x80 >> (column % 8)
    return (byte & bitPosition) == 0
  }
}

/// Game of Life
///
/// Rules:
/// - Any live cell with fewer than two live neighbors dies, as if caused by
///   under-population.
/// - Any live cell with two or three live neighbors lives on to the next
///   generation.
/// - Any live cell with more than three live neighbors dies, as if by
///   overcrowding.
/// - Any dead cell with exactly three live neighbors becomes a live cell, as if
///   by reproduction.
struct Game {
  var playdate: UnsafeMutablePointer<PlaydateAPI>

  func start() {
    playdate.pointee.display.pointee.setRefreshRate!(0)

    if let buffer = playdate.pointee.graphics.pointee.getDisplayFrame() {
      Frame(buffer: buffer).randomize()
    }

    // Note: If you set an update callback in the initialize handler, the
    // system assumes the game is pure C and doesn't run any Lua code in the
    // game.
    let pointer = UnsafeMutableRawPointer(playdate)
    playdate.pointee.system.pointee.setUpdateCallback(update, pointer)
  }

  func updateGame() {
    guard
      // working buffer
      let newBuffer = playdate.pointee.graphics.pointee.getFrame(),
      // buffer currently on screen (or headed there, anyway)
      let oldBuffer = playdate.pointee.graphics.pointee.getDisplayFrame()
    else {
      return
    }

    let newFrame = Frame(buffer: newBuffer)
    let oldFrame = Frame(buffer: oldBuffer)

    var pushed = PDButtons(rawValue: 0)
    playdate.pointee.system.pointee.getButtonState(nil, &pushed, nil)

    if pushed == .a {
      newFrame.randomize()
    } else {
      self.updateFrame(newFrame: newFrame, oldFrame: oldFrame)
    }

    // We twiddled the frame buffer bits directly, so we have to tell the
    // system about it.
    playdate.pointee.graphics.pointee.markUpdatedRows(0, Frame.rows - 1)
  }

  func updateFrame(newFrame: Frame, oldFrame: Frame) {
    var above = oldFrame.row(-1)
    var input = oldFrame.row(0)
    var below = oldFrame.row(1)

    for row in 0..<Frame.rows {
      self.updateRow(
        above: above,
        input: input,
        below: below,
        output: newFrame.row(row))

      above = input
      input = below
      below = oldFrame.row(row + 2)
    }
  }

  func updateRow(above: Row, input: Row, below: Row, output: Row) {
    var byte: UInt8 = 0
    var bitPosition: UInt8 = 0x80

    for column in 0..<Frame.columns {
      // If total is 3 cell is alive
      // If total is 4, no change
      // Else, cell is dead
      let sum =
        above.sum(at: column)
        + input.middleSum(at: column)
        + below.sum(at: column)

      if sum == 3 || (input.isOn(at: column) && sum == 2) {
        byte |= bitPosition
      }

      bitPosition >>= 1

      if bitPosition == 0 {
        output.buffer[Int(column / 8)] = ~byte
        byte = 0
        bitPosition = 0x80
      }
    }
  }
}

@_cdecl("update")
func update(pointer: UnsafeMutableRawPointer!) -> Int32 {
  let playdate = pointer.bindMemory(to: PlaydateAPI.self, capacity: 1)
  Game(playdate: playdate).updateGame()
  return 1
}

@_cdecl("eventHandler")
public func eventHandler(
  pointer: UnsafeMutableRawPointer!,
  event: PDSystemEvent,
  arg: UInt32
) -> Int32 {
  let playdate = pointer.bindMemory(to: PlaydateAPI.self, capacity: 1)
  if event == .initialize {
    Game(playdate: playdate).start()
  }
  return 0
}
