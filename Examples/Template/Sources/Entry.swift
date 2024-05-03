import Playdate

// Opt out of static concurrency checking. We know that the playdate runtime is
// single threaded and this global will never be concurrently accessed.
nonisolated(unsafe) var game = Game()

@_cdecl("eventHandler")
public func eventHandler(
  pointer: UnsafeMutableRawPointer!,
  event: PDSystemEvent,
  arg: UInt32
) -> Int32 {
  initializePlaydateAPI(with: pointer)
  if event == .initialize {
    System.setUpdateCallback(
      update: { _ in
        game.updateGame()
        return 1
      },
      userdata: nil)
  }
  return 0
}
