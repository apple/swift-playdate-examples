public import CPlaydate

public enum ColorStyle: Sendable {
    case solid(LCDSolidColor)
    case pattern(LCDPattern)
}

extension ColorStyle {
    internal func withColorStyle<T>(_ block: (LCDColor) -> T) -> T {
        switch self {
        case .solid(let value):
            block(LCDColor(value.rawValue))
        case .pattern(let pattern):
            withUnsafeBytes(of: pattern) {
                let address = Int(bitPattern: $0.baseAddress.unsafelyUnwrapped)
                return block(LCDColor(address))
            }
        }
    }
}
