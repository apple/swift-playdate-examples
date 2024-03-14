public import Playdate

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
