public import CPlaydate

private var systemAPI: playdate_sys { playdateAPI.system.unsafelyUnwrapped.pointee }

// FIXME: remove callback typealias
@_documentation(visibility: internal)
public typealias PDCallbackFunction = @convention(c) (UnsafeMutableRawPointer?) -> Int32

public enum System {}

extension System {
  /// By default, the accelerometer is disabled to save (a small amount of) power.
  /// To use a peripheral, it must first be enabled via this function.
  /// Accelerometer data is not available until the next update cycle after it’s enabled.
  public static func setPeripheralsEnabled(mask: PDPeripherals) {
    systemAPI.setPeripheralsEnabled.unsafelyUnwrapped(mask)
  }

  /// Returns the last-read accelerometer data.
  public static var accelerometer: (x: Float, y: Float, z: Float) {
    var x: Float = 0.0
    var y: Float = 0.0
    var z: Float = 0.0
    systemAPI.getAccelerometer.unsafelyUnwrapped(&x, &y, &z)
    return (x, y, z)
  }

  /// Option sets indicating which buttons are currently down, and which buttons were pushed or released over the previous
  /// update cycle—at the nominal frame rate of 50 ms, fast button presses can be missed if you just poll the instantaneous state.
  public static var buttonState: (current: PDButtons, pushed: PDButtons, released: PDButtons) {
    var current = PDButtons(rawValue: 0)
    var pushed = PDButtons(rawValue: 0)
    var released = PDButtons(rawValue: 0)
    systemAPI.getButtonState.unsafelyUnwrapped(&current, &pushed, &released)
    return (current, pushed, released)
  }

  /// Returns the current position of the crank, in the range 0-360.
  /// Zero is pointing up, and the value increases as the crank moves clockwise, as viewed from the right side of the device.
  public static var crankAngle: Float {
    systemAPI.getCrankAngle.unsafelyUnwrapped()
  }

  /// Returns the angle change of the crank since the last time this function was called. Negative values are anti-clockwise.
  public static var crankChange: Float {
    systemAPI.getCrankChange.unsafelyUnwrapped()
  }

  /// Returns 1 or 0 indicating whether or not the crank is folded into the unit.
  public static var isCrankDocked: Bool {
    systemAPI.isCrankDocked.unsafelyUnwrapped() != 0
  }
}

// MARK: - Time and Date
extension System {
  /// Returns the number of milliseconds since…​some arbitrary point in time. This should present a consistent timebase while a game is running, but the counter will be disabled when the device is sleeping.
  public static var currentTimeMilliseconds: UInt32 {
    systemAPI.getCurrentTimeMilliseconds.unsafelyUnwrapped()
  }

  /// Returns the number of seconds (and sets milliseconds if not nil) elapsed since midnight (hour 0), January 1, 2000.
  public static func getSecondsSinceEpoch(milliseconds: UnsafeMutablePointer<UInt32>?) -> UInt32 {
    systemAPI.getSecondsSinceEpoch.unsafelyUnwrapped(milliseconds)
  }

  /// Resets the high-resolution timer.
  public static func resetElapsedTime() {
    systemAPI.resetElapsedTime.unsafelyUnwrapped()
  }

  /// Returns the number of seconds since `resetElapsedTime()` was called. The value is a floating-point number with microsecond accuracy.
  public static var elapsedTime: Float {
    systemAPI.getElapsedTime.unsafelyUnwrapped()
  }

  /// Returns the system timezone offset from GMT, in seconds.
  public static var timezoneOffset: Int32 {
    systemAPI.getTimezoneOffset.unsafelyUnwrapped()
  }

  /// Converts the given epoch time to a PDDateTime.
  public static func convertEpochToDateTime(epoch: UInt32, datetime: UnsafeMutablePointer<PDDateTime>) {
    systemAPI.convertEpochToDateTime.unsafelyUnwrapped(epoch, datetime)
  }

  /// Converts the given PDDateTime to an epoch time.
  public static func convertDateTimeToEpoch(datetime: UnsafeMutablePointer<PDDateTime>) -> UInt32 {
    systemAPI.convertDateTimeToEpoch.unsafelyUnwrapped(datetime)
  }

  /// Returns 1 if the user has set the 24-Hour Time preference in the Settings program.
  public static var shouldDisplay24HourTime: Bool {
    systemAPI.shouldDisplay24HourTime.unsafelyUnwrapped() != 0
  }
}

// MARK: - Miscellaneous
extension System {
  /// Returns 1 if the global "flipped" system setting is set, otherwise 0.
  public static var isFlipped: Bool {
    systemAPI.getFlipped.unsafelyUnwrapped() != 0
  }

  /// Returns 1 if the global "reduce flashing" system setting is set, otherwise 0.
  public static var reduceFlashing: Bool {
    systemAPI.getReduceFlashing.unsafelyUnwrapped() != 0
  }

  /// Allocates a buffer `ret` and formats a string. Note that the caller is responsible for freeing `ret`.
  // public static func formatString(format: String, _ arguments: CVarArg...) -> UnsafeMutableRawBufferPointer { }

  /// A game can optionally provide an image to be displayed alongside the system menu.
  ///
  /// - Parameters:
  ///   - bitmap: A 400x240 LCDBitmap. All important content should be in the left half of the image in an area 200 pixels wide, as the menu will obscure the rest.
  ///   - xOffset: Optionally, a non-zero xOffset between 0 and 200. This causes the menu image to animate left by xOffset pixels as the menu is animated in.
  ///
  /// - Note: This function could be called in response to the kEventPause event in your implementation of `eventHandler()`.
  public static func setMenuImage(bitmap: LCDBitmap, xOffset: Int32) {
    systemAPI.setMenuImage.unsafelyUnwrapped(bitmap, xOffset)
  }

  /// Replaces the default Lua run loop function with a custom update function.
  ///
  /// - Parameters:
  ///   - update: The custom update function. It should return a non-zero number to tell the system to update the display, or zero if update isn’t needed.
  ///   - userdata: User-specific data to be passed to the update function.
  public static func setUpdateCallback(update: @escaping PDCallbackFunction, userdata: UnsafeMutableRawPointer?) {
    systemAPI.setUpdateCallback.unsafelyUnwrapped(update, userdata)
  }

  /// Calculates the current frames per second and draws that value at `x`, `y`.
  public static func drawFPS(x: Int32, y: Int32) {
    systemAPI.drawFPS.unsafelyUnwrapped(x, y)
  }

  /// Returns a value from 0-100 denoting the current level of battery charge. 0 = empty; 100 = full.
  public static var batteryPercentage: Float {
    systemAPI.getBatteryPercentage.unsafelyUnwrapped()
  }

  /// Returns the battery’s current voltage level.
  public static var batteryVoltage: Float {
    systemAPI.getBatteryVoltage.unsafelyUnwrapped()
  }

  /// Flushes the CPU instruction cache, on the very unlikely chance you’re modifying instruction code on the fly.
  ///
  /// - Warning: If you don’t know what I’m talking about, you don’t need this.
  public static func clearICache() {
    systemAPI.clearICache.unsafelyUnwrapped()
  }
  
  /// Reallocates a pointer.
  /// If `pointer == nil`, and `size > 0`, allocates a new pointer.
  /// If `pointer != nil` and `size == 0` deallocates the pointer.
  public static func realloc(pointer: UnsafeMutableRawPointer?, size: size_t) -> UnsafeMutableRawPointer? {
    systemAPI.realloc.unsafelyUnwrapped(pointer, size)
  }

  /// Frees a pointer previously allocated with `realloc()`.
  public static func free<T>(pointer: UnsafeMutablePointer<T>) {
    let _ = systemAPI.realloc.unsafelyUnwrapped(pointer, 0)
  }
}
