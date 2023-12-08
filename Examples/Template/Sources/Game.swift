import Playdate

struct Game {
  init() {
    // Setup the device before any other operations.
    srand(System.getSecondsSinceEpoch(milliseconds: nil))
    Display.setRefreshRate(rate: 50)
  }

  mutating func updateGame() {

  }
}
