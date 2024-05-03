import CPlaydate

var graphicsAPI: playdate_graphics { playdateAPI.graphics.unsafelyUnwrapped.pointee }

/// Access the Playdate graphics system.
public enum Graphics {}

extension Graphics {
  /// Pushes a new drawing context for drawing into the given bitmap.
  ///
  /// If target is nil, the drawing functions will use the display framebuffer.
  public static func pushContext(target: OpaquePointer?) {
    graphicsAPI.pushContext.unsafelyUnwrapped(target)
  }

  /// Pops a context off the stack (if any are left), restoring the
  /// drawing settings from before the context was pushed.
  public static func popContext() {
    graphicsAPI.popContext.unsafelyUnwrapped()
  }

  /// Sets the stencil used for drawing.
  ///
  /// For a tiled stencil, use ``setStencilImage(stencil:tile:)`` instead.
  public static func setStencil(stencil: OpaquePointer?) {
    graphicsAPI.setStencil.unsafelyUnwrapped(stencil)
  }

  /// Sets the stencil used for drawing.
  ///
  /// If the tile flag is set the stencil image will be tiled. Tiled
  /// stencils must have width equal to a multiple of 32 pixels.
  public static func setStencilImage(stencil: OpaquePointer?, tile: Int32) {
    graphicsAPI.setStencilImage.unsafelyUnwrapped(stencil, tile)
  }

  /// Sets the mode used for drawing bitmaps.
  ///
  /// Note that text drawing uses bitmaps, so this affects how fonts are
  /// displayed as well.
  public static func setDrawMode(mode: LCDBitmapDrawMode) {
    graphicsAPI.setDrawMode.unsafelyUnwrapped(mode)
  }

  /// Sets the current clip rect, using world coordinates.
  ///
  /// The given rectangle will be translated by the current drawing offset.
  /// The clip rect is cleared at the beginning of each update.
  public static func setClipRect(x: Int32, y: Int32, width: Int32, height: Int32) {
    graphicsAPI.setClipRect.unsafelyUnwrapped(x, y, width, height)
  }

  /// Sets the current clip rect in screen coordinates.
  public static func setScreenClipRect(x: Int32, y: Int32, width: Int32, height: Int32) {
    graphicsAPI.setScreenClipRect.unsafelyUnwrapped(x, y, width, height)
  }

  /// Clears the current clip rect.
  public static func clearClipRect() {
    graphicsAPI.clearClipRect.unsafelyUnwrapped()
  }

  /// Sets the end cap style used in the line drawing functions.
  public static func setLineCapStyle(endCapStyle: LCDLineCapStyle) {
    graphicsAPI.setLineCapStyle.unsafelyUnwrapped(endCapStyle)
  }

  /// Sets the font to use in subsequent drawText calls.
  public static func setFont(font: OpaquePointer?) {
    graphicsAPI.setFont.unsafelyUnwrapped(font)
  }

  /// Sets the tracking to use when drawing text.
  public static func setTextTracking(tracking: Int32) {
    graphicsAPI.setTextTracking.unsafelyUnwrapped(tracking)
  }

  /// Gets the tracking used when drawing text.
  public static func getTextTracking() -> Int32 {
    graphicsAPI.getTextTracking.unsafelyUnwrapped()
  }

  /// Sets the leading adjustment (added to the leading specified in the font) to use when drawing text.
  public static func setTextLeading(leading: Int32) {
    graphicsAPI.setTextLeading.unsafelyUnwrapped(leading)
  }
}

// MARK: - Bitmaps
extension Graphics {
  /// Clears bitmap, filling with the given bgcolor.
  public static func clearBitmap(bitmap: OpaquePointer, bgcolor: LCDColor) {
    graphicsAPI.clearBitmap.unsafelyUnwrapped(bitmap, bgcolor)
  }

  /// Returns a new LCDBitmap that is an exact copy of bitmap.
  public static func copyBitmap(bitmap: OpaquePointer) -> OpaquePointer? {
    graphicsAPI.copyBitmap.unsafelyUnwrapped(bitmap)
  }

  /// Returns 1 if any of the opaque pixels in bitmap1 when positioned at x1, y1 with flip1 overlap any of the opaque pixels in bitmap2 at x2, y2 with flip2 within the non-empty rect, or 0 if no pixels overlap or if one or both fall completely outside of rect.
  public static func checkMaskCollision(
    bitmap1: OpaquePointer, x1: Int32, y1: Int32, flip1: LCDBitmapFlip,
    bitmap2: OpaquePointer, x2: Int32, y2: Int32, flip2: LCDBitmapFlip,
    rect: LCDRect
  ) -> Int32 {
    graphicsAPI.checkMaskCollision.unsafelyUnwrapped(bitmap1, x1, y1, flip1, bitmap2, x2, y2, flip2, rect)
  }

  /// Draws the bitmap with its upper-left corner at location x, y, using the given flip orientation.
  public static func drawBitmap(bitmap: OpaquePointer, x: Int32, y: Int32, flip: LCDBitmapFlip) {
    graphicsAPI.drawBitmap.unsafelyUnwrapped(bitmap, x, y, flip)
  }

  /// Draws the bitmap scaled to xscale and yscale with its upper-left corner at location x, y. Note that flip is not available when drawing scaled bitmaps but negative scale values will achieve the same effect.
  public static func drawScaledBitmap(bitmap: OpaquePointer, x: Int32, y: Int32, xscale: Float, yscale: Float) {
    graphicsAPI.drawScaledBitmap.unsafelyUnwrapped(bitmap, x, y, xscale, yscale)
  }

  /// Draws the bitmap scaled to xscale and yscale then rotated by degrees with its center as given by proportions centerx and centery at x, y.
  public static func drawRotatedBitmap(
    bitmap: OpaquePointer, x: Int32, y: Int32, degrees: Float,
    centerx: Float, centery: Float, xscale: Float, yscale: Float
  ) {
    graphicsAPI.drawRotatedBitmap.unsafelyUnwrapped(bitmap, x, y, degrees, centerx, centery, xscale, yscale)
  }

  /// Frees the given bitmap.
  public static func freeBitmap(bitmap: OpaquePointer) {
    graphicsAPI.freeBitmap.unsafelyUnwrapped(bitmap)
  }

  /// Gets various info about bitmap including its width and height and raw pixel data. The data is 1 bit per pixel packed format, in MSB order.
  public static func getBitmapData(
    bitmap: OpaquePointer, width: UnsafeMutablePointer<Int32>,
    height: UnsafeMutablePointer<Int32>?, rowbytes: UnsafeMutablePointer<Int32>?,
    mask: UnsafeMutablePointer<UnsafeMutablePointer<UInt8>?>?,
    data: UnsafeMutablePointer<UnsafeMutablePointer<UInt8>?>?
  ) {
    graphicsAPI.getBitmapData.unsafelyUnwrapped(bitmap, width, height, rowbytes, mask, data)
  }

  /// Allocates and returns a new LCDBitmap from the file at path. If there is no file at path, the function returns null.
  public static func loadBitmap(path: StaticString) -> OpaquePointer {
    let result = graphicsAPI.loadBitmap(path.utf8Start, nil)
    guard let result = result else { fatalError() }
    return result
  }

  /// Loads the image at path into the previously allocated bitmap.
  public static func loadIntoBitmap(path: StaticString, bitmap: OpaquePointer) {
    graphicsAPI.loadIntoBitmap(path.utf8Start, bitmap, nil)
  }

  /// Allocates and returns a new width by height LCDBitmap filled with bgcolor.
  public static func newBitmap(width: Int32, height: Int32, bgcolor: LCDColor) -> OpaquePointer? {
    graphicsAPI.newBitmap.unsafelyUnwrapped(width, height, bgcolor)
  }

  /// Draws the bitmap with its upper-left corner at location x, y tiled inside a width by height rectangle.
  public static func tileBitmap(bitmap: OpaquePointer, x: Int32, y: Int32, width: Int32, height: Int32, flip: LCDBitmapFlip) {
    graphicsAPI.tileBitmap.unsafelyUnwrapped(bitmap, x, y, width, height, flip)
  }

  /// Returns a new, rotated and scaled LCDBitmap based on the given bitmap.
  public static func rotatedBitmap(bitmap: OpaquePointer, rotation: Float, xscale: Float, yscale: Float) -> (OpaquePointer?, Int32) {
    var allocatedSize: Int32 = 0
    let result = graphicsAPI.rotatedBitmap.unsafelyUnwrapped(bitmap, rotation, xscale, yscale, &allocatedSize)
    return (result, allocatedSize)
  }

  /// Sets a mask image for the given bitmap. The set mask must be the same size as the target bitmap.
  public static func setBitmapMask(bitmap: OpaquePointer, mask: OpaquePointer) -> Int32 {
    graphicsAPI.setBitmapMask.unsafelyUnwrapped(bitmap, mask)
  }

  /// Gets a mask image for the given bitmap. If the image doesn’t have a mask, getBitmapMask returns NULL.
  public static func getBitmapMask(bitmap: OpaquePointer) -> OpaquePointer? {
    graphicsAPI.getBitmapMask.unsafelyUnwrapped(bitmap)
  }
}

// MARK: - Geometry
extension Graphics {
  /// Draws an ellipse inside the rectangle {x, y, width, height} of width lineWidth (inset from the rectangle bounds). If `startAngle != _endAngle`, this draws an arc between the given angles. Angles are given in degrees, clockwise from due north.
  public static func drawEllipse(x: Int32, y: Int32, width: Int32, height: Int32, lineWidth: Int32, startAngle: Float, endAngle: Float, color: LCDColor) {
    graphicsAPI.drawEllipse.unsafelyUnwrapped(x, y, width, height, lineWidth, startAngle, endAngle, color)
  }

  /// Fills an ellipse inside the rectangle {x, y, width, height}. If `startAngle != _endAngle`, this draws a wedge/Pacman between the given angles. Angles are given in degrees, clockwise from due north.
  public static func fillEllipse(x: Int32, y: Int32, width: Int32, height: Int32, startAngle: Float, endAngle: Float, color: LCDColor) {
    graphicsAPI.fillEllipse.unsafelyUnwrapped(x, y, width, height, startAngle, endAngle, color)
  }

  /// Draws a line from x1, y1 to x2, y2 with a stroke width of width.
  public static func drawLine(x1: Int32, y1: Int32, x2: Int32, y2: Int32, width: Int32, color: LCDColor) {
    graphicsAPI.drawLine.unsafelyUnwrapped(x1, y1, x2, y2, width, color)
  }

  /// Draws a width by height rect at x, y.
  public static func drawRect(x: Int32, y: Int32, width: Int32, height: Int32, color: LCDColor) {
    graphicsAPI.drawRect.unsafelyUnwrapped(x, y, width, height, color)
  }

  /// Draws a filled width by height rect at x, y.
  public static func fillRect(x: Int32, y: Int32, width: Int32, height: Int32, color: LCDColor) {
    graphicsAPI.fillRect.unsafelyUnwrapped(x, y, width, height, color)
  }

  /// Draws a filled triangle with points at x1, y1, x2, y2, and x3, y3.
  public static func fillTriangle(x1: Int32, y1: Int32, x2: Int32, y2: Int32, x3: Int32, y3: Int32, color: LCDColor) {
    graphicsAPI.fillTriangle.unsafelyUnwrapped(x1, y1, x2, y2, x3, y3, color)
  }

  /// Fills the polygon with vertices at the given coordinates using the given color and fill, or winding, rule.
  public static func fillPolygon(nPoints: Int32, points: UnsafeMutablePointer<Int32>?, color: LCDColor, fillRule: LCDPolygonFillRule) {
    graphicsAPI.fillPolygon.unsafelyUnwrapped(nPoints, points, color, fillRule)
  }
}

// MARK: - Miscellaneous
extension Graphics {
  /// Returns the current display frame buffer. Rows are 32-bit aligned, so the
  /// row stride is 52 bytes, with the extra 2 bytes per row ignored. Bytes are
  /// MSB-ordered; i.e., the pixel in column 0 is the 0x80 bit of the first byte
  /// of the row.
  public static func getFrame() -> UnsafeMutablePointer<UInt8>? {
    graphicsAPI.getFrame.unsafelyUnwrapped()
  }

  /// Returns the raw bits in the display buffer, the last completed frame.
  public static func getDisplayFrame() -> UnsafeMutablePointer<UInt8>? {
    graphicsAPI.getDisplayFrame.unsafelyUnwrapped()
  }

  /// After updating pixels in the buffer returned by getFrame(), you must tell
  /// the graphics system which rows were updated. This function marks a
  /// contiguous range of rows as updated (e.g., `markUpdatedRows(0,LCD_ROWS-1`)
  /// tells the system to update the entire display). Both “start” and “end” are
  /// included in the range.
  public static func markUpdatedRows(start: Int32, end: Int32) {
    graphicsAPI.markUpdatedRows.unsafelyUnwrapped(start, end)
  }
}
