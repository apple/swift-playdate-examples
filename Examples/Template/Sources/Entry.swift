import Playdate

var game: Game!

@_cdecl("update")
func update(pointer: UnsafeMutableRawPointer?) -> Int32 {
  game.updateGame()
  return 1
}

@_cdecl("eventHandler")
public func eventHandler(
  pointer: UnsafeMutableRawPointer!,
  event: PDSystemEvent,
  arg: UInt32
) -> Int32 {
  playdate = pointer.bindMemory(to: PlaydateAPI.self, capacity: 1)
  if event == .initialize {
    game = Game()
    System.setUpdateCallback(update: update, userdata: nil)
  }
  return 0
}
