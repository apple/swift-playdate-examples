import Playdate

typealias Vector = SIMD2<Float32>

extension Vector {
  init(_ collisionVector: CollisionVector) {
    self = .init(Float32(collisionVector.x), Float32(collisionVector.y))
  }

  init(radius: Float32, theta: Float32) {
    self = .init(radius * cosf(theta), radius * sinf(theta))
  }
}

extension Vector {
  func reflected(along normal: Self) -> Self {
    self - (2 * (self • normal)) * normal
  }

  mutating func reflect(along normal: Self) {
    self = self.reflected(along: normal)
  }
}

extension Vector {
  func rotated(by theta: Float32) -> Self {
    .init(
      x: self.x * cosf(theta) + self.y * -sinf(theta),
      y: self.x * sinf(theta) + self.y * +cosf(theta))
  }

  mutating func rotate(by theta: Float32) {
    self = self.rotated(by: theta)
  }
}

infix operator • : MultiplicationPrecedence
extension Vector {
  static func • (lhs: Self, rhs: Self) -> Float {
    (lhs.x * rhs.x) + (lhs.y * rhs.y)
  }
}
