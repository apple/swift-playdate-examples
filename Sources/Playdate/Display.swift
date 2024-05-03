import CPlaydate

var displayAPI: playdate_display { playdateAPI.display.unsafelyUnwrapped.pointee }

/// Access the Playdate display.
public enum Display {}

extension Display {
  /// The height of the display, taking the current scale into account.
  ///
  /// For example, if the scale is 2, `height` is 120 instead of 240.
  public static var height: Int32 {
    displayAPI.getHeight.unsafelyUnwrapped()
  }

  /// The width of the display, taking the current scale into account.
  ///
  /// For example, if the scale is 2, `width` is 200 instead of 400.
  public static var width: Int32 {
    displayAPI.getWidth.unsafelyUnwrapped()
  }

  /// Sets whether to draw the frame buffer as inverted.
  ///
  /// If `flag` is `true`, the frame buffer is drawn inverted:
  /// black instead of white, and vice versa.
  public static func setInverted(_ flag: Bool) {
    displayAPI.setInverted.unsafelyUnwrapped(flag ? 1 : 0)
  }

  /// Adds a mosaic effect to the display.
  ///
  /// Valid `x` and `y` values are between 0 and 3, inclusive.
  public static func setMosaic(x: UInt32, y: UInt32) {
    displayAPI.setMosaic.unsafelyUnwrapped(x, y)
  }

  /// Flips the display on the x- or y-axis, or both.
  public static func setFlipped(x: Bool, y: Bool) {
    displayAPI.setFlipped.unsafelyUnwrapped(x ? 1 : 0, y ? 1 : 0)
  }

  /// Sets the nominal refresh rate in frames per second (fps).
  ///
  /// The default frame rate is 20 fps, the maximum rate supported by the
  /// hardware for full-frame updates.
  public static func setRefreshRate(rate: Float) {
    displayAPI.setRefreshRate.unsafelyUnwrapped(rate)
  }

  /// Sets the display scale factor.
  ///
  /// The top-left corner of the frame buffer is scaled up to fill the display.
  /// For example, if the scale is set to 4, the pixels in rectangle
  /// `[0,100] x [0,60]` are drawn on the screen as 4 x 4 squares.
  ///
  /// - Parameter scale: Valid values are `1`, `2`, `4`, and `8`.
  public static func setScale(s scale: UInt32) {
    displayAPI.setScale.unsafelyUnwrapped(scale)
  }

  /// Offsets the display by the given amount.
  ///
  /// Areas outside of the displayed area are filled with the current
  /// background color.
  public static func setOffset(dx: Int32, dy: Int32) {
    displayAPI.setOffset.unsafelyUnwrapped(dx, dy)
  }
}
