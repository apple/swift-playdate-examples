import Playdate

enum State {
  case loading
  case running(ActiveGame)
  case paused(ActiveGame)
  case gameOver
}

struct Sprites: ~Copyable {
  var splash: Sprite
  var paused: Sprite
  var ball: Sprite
  var paddle: Sprite
  var gameOver: Sprite
  var bricks: FixedArray<Sprite>
}

struct ActiveGame {
  var score: Int
  var ballVelocity: Vector
  var bricksRemaining: Int
}

struct Game: ~Copyable {
  var state: State
  var sprites: Sprites

  init() {
    // Setup the device before any other operations.
    srand(System.getSecondsSinceEpoch(milliseconds: nil))
    Display.setRefreshRate(rate: 50)

    // Add the background and walls to the sprite system.
    Sprite.setupBackground()
    Sprite.setupWalls()

    // Start in loading state with 4 x 10 bricks.
    let brick = Sprite.brick()
    let splash = Sprite.splash()
    splash.addSprite()
    self.sprites =
      .init(
        splash: splash,
        paused: .paused(),
        ball: .ball(),
        paddle: .paddle(),
        gameOver: .gameOver(),
        bricks: .init(count: 40, first: brick) { $0.copy() })
    Sprite.drawSprites()
    self.state = .loading
  }
}

extension Game {
  mutating func updateGame() {
    let pushed = System.buttonState.pushed
    switch self.state {
    case .loading:
      if pushed == .a {
        self.startNewGame()
      }

    case .running(let activeGame):
      if pushed == .b {
        self.pause(activeGame)
        break
      }

      let ballY = sprites.ball.position.y
      let bounds = sprites.ball.bounds
      if ballY > Float(LCD_ROWS) + bounds.width {
        self.gameOver()
        break
      }

      if activeGame.bricksRemaining == 0 {
        self.startNewLevel(activeGame)
        break
      }

    case .paused(let activeGame):
      if pushed == .b {
        self.resume(activeGame)
      }

    case .gameOver:
      if pushed == .a {
        self.startNewGame()
      }
    }

    Sprite.updateAndDrawSprites()
  }

  mutating func startNewGame() {
    self.sprites.splash.removeSprite()
    self.sprites.gameOver.removeSprite()
    let activeGame = ActiveGame(
      score: 0,
      ballVelocity: .zero,
      bricksRemaining: 0)
    self.startNewLevel(activeGame)
  }

  mutating func startNewLevel(_ activeGame: consuming ActiveGame) {
    // Determine a random starting vector for the ball.
    //    -pi/2
    //      |
    // pi --+-- 0
    //      |
    //     pi/2
    let percentage = Float(rand()) / Float(RAND_MAX)
    activeGame.ballVelocity = .init(radius: 3, theta: -.pi * percentage)

    self.sprites.ball.moveTo(
      x: Float(LCD_COLUMNS / 2),
      y: Float(3 * LCD_ROWS / 4))
    self.sprites.ball.addSprite()

    self.sprites.paddle.moveTo(
      x: Float(LCD_COLUMNS / 2),
      y: Float(LCD_ROWS - 12))
    self.sprites.paddle.addSprite()

    let brickWidth = 40
    let brickHeight = 24
    sprites.bricks.enumerated { index, brick in
      let x = (index % 10)
      let y = (index / 10)
      brick.moveTo(
        x: Float(x * brickWidth + brickWidth / 2),
        y: Float(y * brickHeight + brickHeight / 2))
      brick.addSprite()
    }
    activeGame.bricksRemaining = sprites.bricks.count

    self.state = .running(activeGame)
  }

  mutating func pause(_ activeGame: ActiveGame) {
    self.sprites.gameOver.moveTo(
      x: Float(LCD_COLUMNS / 2),
      y: Float(LCD_ROWS / 2))
    self.sprites.paused.addSprite()
    self.state = .paused(activeGame)
  }

  mutating func resume(_ activeGame: ActiveGame) {
    self.sprites.paused.removeSprite()
    self.state = .running(activeGame)
  }

  mutating func gameOver() {
    self.sprites.ball.removeSprite()
    self.sprites.paddle.removeSprite()
    self.sprites.bricks.forEach { brick in
      brick.removeSprite()
    }
    self.sprites.gameOver.moveTo(
      x: Float(LCD_COLUMNS / 2),
      y: Float(LCD_ROWS / 2))
    self.sprites.gameOver.addSprite()
    self.state = .gameOver
  }
}
