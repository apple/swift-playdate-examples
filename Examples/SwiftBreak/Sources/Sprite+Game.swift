import Playdate

extension Sprite {
  init(bitmapPath: StaticString) {
    let bitmap = Graphics.loadBitmap(path: bitmapPath)
    var width: Int32 = 0
    var height: Int32 = 0
    Graphics.getBitmapData(
      bitmap: bitmap,
      width: &width,
      height: &height,
      rowbytes: nil,
      mask: nil,
      data: nil)
    let bounds = PDRect(x: 0, y: 0, width: Float(width), height: Float(height))

    self.init()
    self.setImage(image: bitmap)
    self.bounds = bounds
    self.collideRect = bounds
  }
}

extension Sprite {
  static func setupBackground() {
    var sprite = Sprite(bitmapPath: "background.png")
    sprite.collisionsEnabled = false
    sprite.zIndex = 0
    sprite.addSprite()
    sprite.forget()
  }

  static func setupWalls() {
    let bar: Float = 10
    let walls: [PDRect] = [
      .init(x: -bar, y: -bar, width: Float(LCD_COLUMNS), height: bar),
      .init(x: -bar, y: -bar, width: bar, height: Float(LCD_ROWS)),
      .init(x: Float(LCD_COLUMNS), y: -bar, width: bar, height: Float(LCD_ROWS)),
    ]

    for wall in walls {
      var sprite = Sprite()
      let bounds = PDRect(x: 0, y: 0, width: wall.width, height: wall.height)
      sprite.bounds = bounds
      sprite.collideRect = bounds
      sprite.setCollisionResponseFunction { _, _ in .collisionTypeBounce }
      sprite.moveTo(x: wall.x + wall.width / 2, y: wall.y + wall.height / 2)
      sprite.addSprite()
      sprite.forget()
    }
  }

  static func splash() -> Sprite {
    var sprite = Sprite(bitmapPath: "splash.png")
    sprite.collisionsEnabled = false
    return sprite
  }

  static func paused() -> Sprite {
    var sprite = Sprite(bitmapPath: "paused.png")
    sprite.collisionsEnabled = false
    return sprite
  }

  static func ball() -> Sprite {
    let sprite = Sprite(bitmapPath: "ball.png")
    sprite.setCollisionResponseFunction { _, _ in .collisionTypeBounce }
    sprite.setUpdateFunction { ptr in
      let sprite = Sprite(borrowing: ptr.unsafelyUnwrapped)
      guard case .running(var activeGame) = game.state else { return }

      let (x, y) = sprite.position
      let newX = x + activeGame.ballVelocity.x
      let newY = y + activeGame.ballVelocity.y

      sprite.moveWithCollisions(goalX: newX, goalY: newY) { _, _, collisions in
        for collision in collisions {
          let otherSprite = Sprite(borrowing: collision.other)

          if otherSprite.tag == .brick, otherSprite.isVisible {
            otherSprite.removeSprite()
            activeGame.score += 1
            activeGame.bricksRemaining -= 1
          }

          var normal = Vec2(collision.normal)

          if otherSprite.tag == .paddle {
            // compute placement of ball on paddle in domain -1 to 1.
            //      ball
            //       x
            //  -1 ----- 0 ----- 1
            //    paddle
            let paddleBounds = otherSprite.bounds
            let paddleHalfWidth = paddleBounds.width / 2
            let paddleMidX = paddleBounds.x + paddleHalfWidth
            let ballX = collision.touch.x
            let placement = (ballX - paddleMidX) / paddleHalfWidth

            // Compute deflection angle (radians) for the normal in domain
            // -pi/6 to pi/6.
            let deflectionAngle = placement * (.pi / 6)
            normal.rotate(by: deflectionAngle)
          }

          activeGame.ballVelocity.reflect(along: normal)
        }
      }
      game.state = .running(activeGame)
    }
    return sprite
  }

  static func paddle() -> Sprite {
    var sprite = Sprite(bitmapPath: "paddle.png")
    sprite.tag = .paddle
    sprite.setUpdateFunction { spritePtr in
      guard case .running = game.state else { return }

      let sprite = Sprite(borrowing: spritePtr.unsafelyUnwrapped)
      let current = System.buttonState.current

      let dx: Float =
        if current == .left, current != .right {
          -5.0
        } else if current != .left, current == .right {
          5.0
        } else {
          System.crankChange
        }

      let (x, y) = sprite.position
      let bounds = sprite.bounds

      let minX = (bounds.width / 2) + 5
      let maxX = Float(LCD_COLUMNS) - (bounds.width / 2) - 5
      let newX = max(min(x + dx, maxX), minX)
      let newY = y

      sprite.moveWithCollisions(goalX: newX, goalY: newY)
    }
    return sprite
  }

  static func gameOver() -> Sprite {
    var sprite = Sprite(bitmapPath: "game-over.png")
    sprite.collisionsEnabled = false
    return sprite
  }

  static func brick() -> Sprite {
    var sprite = Sprite(bitmapPath: "brick.png")
    sprite.tag = .brick
    return sprite
  }
}

extension Sprite.Tag {
  static let paddle = Self(0x1)
  static let ball = Self(0x2)
  static let brick = Self(0x3)
}
