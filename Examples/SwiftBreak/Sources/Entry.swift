#if swift(>=6.0)
public import Playdate
#else
import Playdate
#endif

// Opt out of static concurrency checking. We know that the playdate runtime is
// single threaded and this global will never be concurrently accessed.
nonisolated(unsafe) var game = Game()

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
  initializePlaydateAPI(with: pointer)
  if event == .initialize {
    System.setUpdateCallback(update: update, userdata: nil)
  }
  return 0
}
