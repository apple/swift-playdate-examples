struct FixedArray<Element: ~Copyable>: ~Copyable {
    let count: Int
    private let _buffer: UnsafeMutablePointer<Element>

    init(count: Int, first: consuming Element, rest: (borrowing Element)->Element) {
        precondition(count > 0)
        self.count = count
        _buffer = .allocate(capacity: count)
        for i in 1..<count {
            (_buffer + i).initialize(to: rest(first))
        }
        _buffer.initialize(to: first)
    }

    deinit {
        _buffer.deinitialize(count: count)
        _buffer.deallocate()
    }
}

extension FixedArray where Element: ~Copyable {
  func forEach(_ body: (borrowing Element)->Void) {
    for i in 0..<self.count {
      body((self._buffer + i).pointee)
    }
  }

  func enumerated(_ body: (Int, borrowing Element)->Void) {
    var i = 0
    self.forEach {
      body(i, $0)
      i += 1
    }
  }
}
