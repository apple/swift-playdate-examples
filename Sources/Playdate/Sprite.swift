import CPlaydate

/// Access to the Playdate sprite API.
var spriteAPI: playdate_sprite { playdateAPI.sprite.unsafelyUnwrapped.pointee }

// FIXME: remove typealiases
@_documentation(visibility: internal)
public typealias LCDBitmap = OpaquePointer?
@_documentation(visibility: internal)
public typealias LCDSpriteDrawFunction = @convention(c) (OpaquePointer?, PDRect, PDRect) -> Void
@_documentation(visibility: internal)
public typealias LCDSpriteUpdateFunction = @convention(c) (OpaquePointer?) -> Void
@_documentation(visibility: internal)
public typealias LCDSpriteCollisionFilterProc = @convention(c) (OpaquePointer?, OpaquePointer?) -> SpriteCollisionResponseType

/// A sprite is a graphics object that can be used to represent moving entities
/// in your programs.
public struct Sprite: ~Copyable {
  var owned: Bool
  let pointer: OpaquePointer

  /// Allocates and returns a new sprite, which will be owned by this instance
  /// and freed when the last copy goes away.
  public init() {
    self.pointer = spriteAPI.newSprite.unsafelyUnwrapped()!
    self.owned = true
  }

  /// Create a Sprite wrapper around an existing sprite pointer, taking
  /// ownership over that sprite pointer.
  public init(owning pointer: OpaquePointer) {
    self.pointer = pointer
    self.owned = true
  }

  /// Create a Sprite wrapper around an existing sprite pointer, borrowing that
  /// sprite without taking ownership of it.
  public init(borrowing pointer: OpaquePointer) {
    self.pointer = pointer
    self.owned = false
  }

  /// "Forget" this sprite instance, relinquishing ownership of it so that it
  /// will not be automatically freed. Use this operation for sprites whose
  /// ownership should no longer be managed automatically, for example because
  /// they will persist for the life of the game or because the user wants to
  /// explicitly free them at some other point.
  public mutating func forget() {
    self.owned = false
  }

  deinit {
    if owned {
      spriteAPI.freeSprite(self.pointer)
    }
  }
}

extension Sprite {
  /// Allocates and returns a copy of the given sprite.
  public func copy() -> Sprite {
    Sprite(owning: spriteAPI.copy.unsafelyUnwrapped(self.pointer)!)
  }
}

// MARK - Properties
extension Sprite {
  /// The bounds of the sprite as an PDRect
  public var bounds: PDRect {
    get { spriteAPI.getBounds.unsafelyUnwrapped(self.pointer) }
    set { spriteAPI.setBounds.unsafelyUnwrapped(self.pointer, newValue) }
  }

  /// Moves the given sprite to the specified position (x, y) and resets its
  /// bounds based on the bitmap dimensions and center.
  public func moveTo(x: Float, y: Float) {
    spriteAPI.moveTo.unsafelyUnwrapped(self.pointer, x, y)
  }

  /// Moves the given sprite by offsetting its current position by the specified
  /// delta values (dx, dy).
  public func moveBy(dx: Float, dy: Float) {
    spriteAPI.moveBy.unsafelyUnwrapped(self.pointer, dx, dy)
  }

  /// The x and y position of the sprite.
  public var position: (x: Float, y: Float) {
    var x: Float = 0.0
    var y: Float = 0.0
    spriteAPI.getPosition.unsafelyUnwrapped(self.pointer, &x, &y)
    return (x, y)
  }

  /// The sprite’s drawing center as a fraction (ranging from 0.0 to 1.0) of the
  /// height and width.
  ///
  /// Default is 0.5, 0.5 (the center of the sprite).
  ///
  /// This means that when you call `moveTo(x:y:)`, the center of your sprite
  /// will be positioned at x, y. If you want x and y to represent the upper
  /// left corner of your sprite, specify the center as 0, 0.
  var center: (x: Float, y: Float) {
    get {
      var x: Float = 0.0
      var y: Float = 0.0
      spriteAPI.getCenter.unsafelyUnwrapped(self.pointer, &x, &y)
      return (x, y)
    }
    set { spriteAPI.setCenter.unsafelyUnwrapped(self.pointer, newValue.x, newValue.y) }
  }

  /// Sets the given sprite's image to the given bitmap.
  public func setImage(image: LCDBitmap, flip: LCDBitmapFlip = .bitmapUnflipped) {
    spriteAPI.setImage.unsafelyUnwrapped(self.pointer, image, flip)
  }

  /// Returns the LCDBitmap currently assigned to the given sprite.
  var image: LCDBitmap? {
    spriteAPI.getImage.unsafelyUnwrapped(self.pointer)
  }

  /// Sets the size.
  ///
  /// The size is used to set the sprite’s bounds when calling `moveTo()`.
  public func setSize(width: Float, height: Float) {
    spriteAPI.setSize.unsafelyUnwrapped(self.pointer, width, height)
  }

  /// The Z order of the given sprite.
  ///
  /// Higher Z sprites are drawn on top of those with lower Z order.
  public var zIndex: Int16 {
    get { spriteAPI.getZIndex.unsafelyUnwrapped(self.pointer) }
    set { spriteAPI.setZIndex.unsafelyUnwrapped(self.pointer, newValue) }
  }

  /// Sets the mode for drawing the sprite’s bitmap.
  public func setDrawMode(mode: LCDBitmapDrawMode) {
    spriteAPI.setDrawMode.unsafelyUnwrapped(self.pointer, mode)
  }

  /// The flip setting of the sprite’s bitmap.
  public var imageFlip: LCDBitmapFlip {
    get { spriteAPI.getImageFlip.unsafelyUnwrapped(self.pointer) }
    set { spriteAPI.setImageFlip.unsafelyUnwrapped(self.pointer, newValue) }
  }

  /// Specifies a stencil image to be set on the frame buffer before the sprite
  /// is drawn.
  public func setStencil(stencil: LCDBitmap) {
    spriteAPI.setStencil.unsafelyUnwrapped(self.pointer, stencil)
  }

  /// Specifies a stencil image to be set on the frame buffer before the sprite
  /// is drawn. If tile is set, the stencil will be tiled. Tiled stencils must
  /// have width evenly divisible by 32.
  public func setStencilImage(stencil: LCDBitmap, tile: Int32) {
    spriteAPI.setStencilImage.unsafelyUnwrapped(self.pointer, stencil, tile)
  }

  /// Sets the sprite’s stencil to the given pattern.
  public func setStencilPattern(pattern: UnsafeMutablePointer<UInt8>?) {
    spriteAPI.setStencilPattern.unsafelyUnwrapped(self.pointer, pattern)
  }

  /// Clears the sprite’s stencil.
  public func clearStencil() {
    spriteAPI.clearStencil.unsafelyUnwrapped(self.pointer)
  }

  /// Sets the clipping rectangle for sprite drawing.
  public func setClipRect(clipRect: LCDRect) {
    spriteAPI.setClipRect.unsafelyUnwrapped(self.pointer, clipRect)
  }

  /// Clears the sprite’s clipping rectangle.
  public func clearClipRect() {
    spriteAPI.clearClipRect.unsafelyUnwrapped(self.pointer)
  }

  /// Sets the clipping rectangle for all sprites with a Z index within startZ
  /// and endZ inclusive.
  public func setClipRectsInRange(clipRect: LCDRect, startZ: Int32, endZ: Int32) {
    spriteAPI.setClipRectsInRange.unsafelyUnwrapped(clipRect, startZ, endZ)
  }

  /// Clears the clipping rectangle for all sprites with a Z index within startZ
  /// and endZ inclusive.
  public func clearClipRectsInRange(startZ: Int32, endZ: Int32) {
    spriteAPI.clearClipRectsInRange.unsafelyUnwrapped(startZ, endZ)
  }

  /// The updatesEnabled flag of the given sprite determines whether the sprite
  /// has its update function called.
  public var updatesEnabled: Bool {
    get { spriteAPI.updatesEnabled.unsafelyUnwrapped(self.pointer) != 0 }
    set { spriteAPI.setUpdatesEnabled.unsafelyUnwrapped(self.pointer, newValue ? 1 : 0) }
  }

  /// The visible flag determines whether the sprite has its draw function
  /// called.
  public var isVisible: Bool {
    get { spriteAPI.isVisible.unsafelyUnwrapped(self.pointer) != 0 }
    set { spriteAPI.setVisible.unsafelyUnwrapped(self.pointer, newValue ? 1 : 0) }
  }

  /// Marking a sprite opaque tells the sprite system that it doesn’t need to
  /// draw anything underneath the sprite, since it will be overdrawn anyway. If
  /// you set an image without a mask/alpha channel on the sprite, it
  /// automatically sets the opaque flag.
  public func setOpaque(_ flag: Bool) {
    spriteAPI.setOpaque.unsafelyUnwrapped(self.pointer, flag ? 1 : 0)
  }

  /// When flag is set to 1, the given (?) sprite will always redraw.
  public static func setAlwaysRedraw(_ flag: Bool) {
    spriteAPI.setAlwaysRedraw.unsafelyUnwrapped(flag ? 1 : 0)
  }

  /// Forces the given sprite to redraw.
  public func markDirty() {
    spriteAPI.markDirty.unsafelyUnwrapped(self.pointer)
  }

  /// Marks the given dirtyRect (in screen coordinates) as needing a redraw.
  ///
  /// Graphics drawing functions now call this automatically, adding their drawn
  /// areas to the sprite’s dirty list, so there’s usually no need to call this
  /// manually.
  public static func addDirtyRect(dirtyRect: LCDRect) {
    spriteAPI.addDirtyRect.unsafelyUnwrapped(dirtyRect)
  }

  /// When flag is set to 1, the sprite will draw in screen coordinates,
  /// ignoring the currently-set drawOffset. This only affects drawing and
  /// should not be used on sprites being used for collisions, which will still
  /// happen in world-space.
  public func setIgnoresDrawOffset(flag: Int32) {
    spriteAPI.setIgnoresDrawOffset.unsafelyUnwrapped(self.pointer, flag)
  }

  /// Sets the update function for the given sprite.
  public func setUpdateFunction(func: LCDSpriteUpdateFunction) {
    spriteAPI.setUpdateFunction.unsafelyUnwrapped(self.pointer, `func`)
  }

  /// Sets the draw function for the given sprite.
  public func setDrawFunction(func: LCDSpriteDrawFunction) {
    spriteAPI.setDrawFunction.unsafelyUnwrapped(self.pointer, `func`)
  }

  /// Sets the sprite’s userdata, an arbitrary pointer used for associating the
  /// sprite with other data.
  public var userData: UnsafeMutableRawPointer? {
    get { spriteAPI.getUserdata.unsafelyUnwrapped(self.pointer) }
    set { spriteAPI.setUserdata.unsafelyUnwrapped(self.pointer, newValue) }
  }
}

// MARK: - Display List
extension Sprite {
  /// Adds the given sprite to the display list, so that it is drawn in the
  /// current scene.
  public func addSprite() {
    spriteAPI.addSprite.unsafelyUnwrapped(self.pointer)
  }

  /// Removes the given sprite from the display list.
  public func removeSprite() {
    spriteAPI.removeSprite.unsafelyUnwrapped(self.pointer)
  }

  /// Removes the given count sized array of sprites from the display list.
  public static func removeSprites(sprites: UnsafeMutablePointer<OpaquePointer?>?, count: Int32) {
    spriteAPI.removeSprites.unsafelyUnwrapped(sprites, count)
  }

  /// Removes all sprites from the display list.
  public static func removeAllSprites() {
    spriteAPI.removeAllSprites.unsafelyUnwrapped()
  }

  /// Returns the total number of sprites in the display list.
  public static func getSpriteCount() -> Int32 {
    spriteAPI.getSpriteCount.unsafelyUnwrapped()
  }

  /// Draws every sprite in the display list.
  public static func drawSprites() {
    spriteAPI.drawSprites.unsafelyUnwrapped()
  }

  /// Updates and draws every sprite in the display list.
  public static func updateAndDrawSprites() {
    spriteAPI.updateAndDrawSprites.unsafelyUnwrapped()
  }
}

// MARK: - Collisions
extension Sprite {
  /// Frees and reallocates internal collision data, resetting everything to its
  /// default state.
  public static func resetCollisionWorld() {
    spriteAPI.resetCollisionWorld.unsafelyUnwrapped()
  }

  /// The collisionsEnabled flag, along with the collideRect, determines whether
  /// the sprite participates in collisions. Defaults to true.
  public var collisionsEnabled: Bool {
    get { spriteAPI.collisionsEnabled.unsafelyUnwrapped(self.pointer) != 0 }
    set { spriteAPI.setCollisionsEnabled.unsafelyUnwrapped(self.pointer, newValue ? 1 : 0) }
  }

  /// Marks the area of the given sprite, relative to its bounds, to be checked
  /// for collisions with other sprites' collide rects.
  public var collideRect: PDRect {
    get { spriteAPI.getCollideRect.unsafelyUnwrapped(self.pointer) }
    set { spriteAPI.setCollideRect.unsafelyUnwrapped(self.pointer, newValue) }
  }

  /// Clears the given sprite’s collide rect.
  public func clearCollideRect() {
    spriteAPI.clearCollideRect.unsafelyUnwrapped(self.pointer)
  }

  /// Set a callback that returns a SpriteCollisionResponseType for a collision
  /// between sprite and other.
  public func setCollisionResponseFunction(func: @escaping LCDSpriteCollisionFilterProc) {
    spriteAPI.setCollisionResponseFunction.unsafelyUnwrapped(self.pointer, `func`)
  }

  /// Check for the collisions that would occur when moving the given sprite
  /// towards goalX, goalY.
  ///
  /// - Returns: the position the sprite would have after collisions. If no
  /// collisions occurred, the result will be the same as `goalX`, `goalY`.
  public func checkCollisions(goalX: Float, goalY: Float) -> (actualX: Float, actualY: Float) {
    checkCollisions(goalX: goalX, goalY: goalY) { x, y, _ in
      (actualX: x, actualY: y)
    }
  }

  /// Checks for collisions that will occur when moving given sprite towards
  /// goalX, goalY, with the same behavior as moveWithCollisions but without
  /// actually moving the sprite.
  ///
  /// The given `body` will be provided with the sprite's position after
  /// collisions are taken into account, along with a buffer containing
  /// SpriteCollisionInfo instances describing each collision. If there were no
  /// collisions, the sprite's position will be the same as `goalX`, `goalY` and
  /// the provided buffer will be empty.
  ///
  /// The result produced by calling `body` will be returned from this function.
  public func checkCollisions<T>(
    goalX: Float, goalY: Float,
    body: (_ actualX: Float, _ actualY: Float, _ collisions: UnsafeBufferPointer<SpriteCollisionInfo>) -> T
  ) -> T {
    var count: Int32 = 0
    var actualX: Float = 0
    var actualY: Float = 0

    let rawCollisions = spriteAPI.checkCollisions.unsafelyUnwrapped(self.pointer, goalX, goalY, &actualX, &actualY, &count)
    let collisions = UnsafeBufferPointer(start: rawCollisions, count: Int(count))
    defer { rawCollisions?.deallocate() }
    return body(actualX, actualY, collisions)
  }

  /// Moves the given sprite towards goalX, goalY taking collisions into
  /// account.
  ///
  /// - Returns: the position of the sprite after collisions. If no collisions
  /// occurred, the result will be the same as `goalX`, `goalY`.
  @discardableResult
  public func moveWithCollisions(goalX: Float, goalY: Float) -> (actualX: Float, actualY: Float) {
    moveWithCollisions(goalX: goalX, goalY: goalY) { x, y, _ in
      (actualX: x, actualY: y)
    }
  }

  /// Moves the given sprite towards goalX, goalY taking collisions into
  /// account.
  ///
  /// The given `body` will be provided with the sprite's position after
  /// collisions are taken into account, along with a buffer containing
  /// SpriteCollisionInfo instances describing each collision. If there were no
  /// collisions, the sprite's position will be the same as `goalX`, `goalY` and
  /// the provided buffer will be empty.
  ///
  /// The result produced by calling `body` will be returned from this function.
  public func moveWithCollisions<T>(
    goalX: Float, goalY: Float,
    body: (_ actualX: Float, _ actualY: Float, _ collisions: UnsafeBufferPointer<SpriteCollisionInfo>) -> T
  ) -> T {
    var count: Int32 = 0
    var actualX: Float = 0
    var actualY: Float = 0

    let rawCollisions = spriteAPI.moveWithCollisions.unsafelyUnwrapped(self.pointer, goalX, goalY, &actualX, &actualY, &count)
    let collisions = UnsafeBufferPointer(start: rawCollisions, count: Int(count))
    defer { rawCollisions?.deallocate() }
    return body(actualX, actualY, collisions)
  }

  /// Provide all sprites with collision rects containing the point at x, y to
  /// the given `body` closure and return its result.
  public func querySpritesAtPoint<T>(x: Float, y: Float, body: (UnsafeBufferPointer<OpaquePointer?>) -> T) -> T {
    var count: Int32 = 0
    let rawSprites = spriteAPI.querySpritesAtPoint.unsafelyUnwrapped(x, y, &count)
    let sprites = UnsafeBufferPointer(start: rawSprites, count: Int(count))
    defer { rawSprites?.deallocate() }
    return body(sprites)
  }

  /// Provide all sprites with collision rects that intersect the width by
  /// height rect at x, y to the given `body` closure and return its result.
  public func querySpritesInRect<T>(x: Float, y: Float, width: Float, height: Float, body: (UnsafeBufferPointer<OpaquePointer?>) -> T) -> T {
    var count: Int32 = 0
    let rawSprites = spriteAPI.querySpritesInRect.unsafelyUnwrapped(x, y, width, height, &count)
    let sprites = UnsafeBufferPointer(start: rawSprites, count: Int(count))
    defer { rawSprites?.deallocate() }
    return body(sprites)
  }

  /// Returns an array of all sprites with collision rects that intersect the
  /// line connecting x1, y1 and x2, y2. len is set to the size of the array.
  public func querySpritesAlongLine<T>(x1: Float, y1: Float, x2: Float, y2: Float, body: (UnsafeBufferPointer<OpaquePointer?>) -> T) -> T {
    var count: Int32 = 0
    let rawSprites = spriteAPI.querySpritesAlongLine.unsafelyUnwrapped(x1, y1, x2, y2, &count)
    let sprites = UnsafeBufferPointer(start: rawSprites, count: Int(count))
    defer { rawSprites?.deallocate() }
    return body(sprites)
  }

  /// Returns an array of SpriteQueryInfo for all sprites with collision rects
  /// that intersect the line connecting x1, y1 and x2, y2. len is set to the
  /// size of the array. If you don’t need this information, use
  /// querySpritesAlongLine() as it will be faster.
  public func querySpriteInfoAlongLine<T>(x1: Float, y1: Float, x2: Float, y2: Float, body: (UnsafeBufferPointer<SpriteQueryInfo>) -> T) -> T {
    var count: Int32 = 0
    let rawSprites = spriteAPI.querySpriteInfoAlongLine.unsafelyUnwrapped(x1, y1, x2, y2, &count)
    let sprites = UnsafeBufferPointer(start: rawSprites, count: Int(count))
    defer { rawSprites?.deallocate() }
    return body(sprites)
  }

  /// Returns an array of all sprites that have collide rects that are currently
  /// overlapping.
  ///
  /// Each consecutive pair of sprites is overlapping (eg. 0 & 1 overlap,
  /// 2 & 3 overlap, etc). len is set to the size of the array.
  public func allOverlappingSprites<T>(body: (UnsafeBufferPointer<OpaquePointer?>) -> T) -> T {
    var count: Int32 = 0
    let rawSprites = spriteAPI.allOverlappingSprites.unsafelyUnwrapped(&count)
    let sprites = UnsafeBufferPointer(start: rawSprites, count: Int(count))
    defer { rawSprites?.deallocate() }
    return body(sprites)
  }
}

extension Sprite {
  public struct Tag: Sendable {
    public var id: UInt8

    public init(id: UInt8) {
      self.id = id
    }
  }
}

extension Sprite.Tag: Equatable, Hashable {}

extension Sprite.Tag: ExpressibleByIntegerLiteral {
  public init(integerLiteral value: UInt8) {
    self.id = value
  }
}

extension Sprite {
  /// The tag of the given sprite. This can be useful for identifying sprites or
  /// types of sprites when using the collision API.
  public var tag: Tag {
    get { Tag(id: spriteAPI.getTag.unsafelyUnwrapped(self.pointer)) }
    set { spriteAPI.setTag.unsafelyUnwrapped(self.pointer, newValue.id) }
  }
}
